# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'active_record'
require 'bootstrap-sass'
require 'logger'
require 'sinatra/sprockets-helpers'

class Gallerist::App < Sinatra::Base

  register Sinatra::Sprockets::Helpers

  configure do
    enable :logging

    set :root, File.join(root, '..', '..')

    set :library_path, ENV['GALLERIST_LIBRARY']
    set :views, File.join(root, 'views')

    set :sprockets, Sprockets::Environment.new(root)

    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.cache = Sprockets::Cache::FileStore.new Dir.tmpdir
    sprockets.css_compressor = :scss

    configure_sprockets_helpers do |helpers|
      helpers.debug = development?
    end

    Bootstrap.load!
  end

  configure :development do
    set :logging, ::Logger::DEBUG

    debug_logger = ::Logger.new($stdout, ::Logger::DEBUG)

    sprockets.logger = debug_logger
    ActiveRecord::Base.logger = debug_logger
  end

  error 500 do |error|
    @title = 'Error'

    raise error if env['rack.errors'].is_a? StringIO

    erb :'500'
  end

  helpers Gallerist::Helpers

  def send_library_file(file, options = {})
    logger.debug "Serving file '%s' from library..." % [ file ]

    file_path = File.join(library.path, file)
    response = catch(:halt) { send_file file_path, options }
    if response == 404
      logger.error "File '%s' could not be served, because it does not exist." % file
    end

    halt response
  end

  def library
    unless settings.respond_to? :library
      settings.set :library, Gallerist::Library.new(self, settings.library_path)

      ActiveRecord::Base.establish_connection({
        adapter: 'sqlite3',
        database: library.library_db
      })
      ActiveRecord::Base.connection.exec_query 'PRAGMA journal_mode="MEMORY";'

      Gallerist::ImageProxiesModel.establish_connection({
        adapter: 'sqlite3',
        database: library.image_proxies_db
      })
      Gallerist::ImageProxiesModel.connection.exec_query 'PRAGMA journal_mode="MEMORY";'

      logger.debug "  Found #{library.albums.size} albums."
    end
    settings.library
  end

  def navbar_for(obj)
    @navbar = [[ '/', library.name ]]

    case obj
    when :all_photos
      @navbar << [ '/photos', 'All photos' ]
    when :favorites
      @navbar << [ '/favorites', 'Favorites' ]
    when Gallerist::Album
      @navbar << [ '/albums', 'Albums' ]
      @navbar << [ '/albums/%s' % [ obj.id ], obj.name ]
    when Gallerist::Tag
      @navbar << [ '/tags', 'Tags' ]
      @navbar << [ '/tags/%s' % [ obj.simple_name ], obj.name ]
    end
  end

  def photo(id)
    Gallerist::Photo.find id
  rescue ActiveRecord::RecordNotFound
    logger.error 'Could not find the photo with ID #%s.' % [ id ]
    not_found
  end

  def self.setup_default_middleware(builder)
    builder.use Sinatra::ExtendedRack
    builder.use Gallerist::ShowExceptions if show_exceptions?
    builder.use Gallerist::RaiseWarmupExceptions

    setup_logging builder
  end

  get '/' do
    @title = library.name

    @albums = library.albums.visible.nonempty.order :date
    @tags = library.tags.nonempty.order 'photos_count desc'

    navbar_for :root

    erb :index
  end

  get '/albums/:id' do
    @album = library.albums.find params[:id]
    @title = @album.name

    navbar_for @album

    erb :album
  end

  get '/favorites' do
    @photos = library.photos.favorites
    @title = 'Favorites'

    navbar_for :favorites

    erb :photos
  end

  get '/photos' do
    @photos = library.photos
    @title = 'All photos'

    navbar_for :all_photos

    erb :photos
  end

  get '/photos/:id' do
    photo = photo params[:id]

    send_library_file photo.image_path,
      disposition: :inline,
      filename: photo.file_name
  end

  get '/tags/:name' do
    @tag = library.tags.find_by_simple_name params[:name]
    @title = @tag.name

    navbar_for @tag

    erb :tag
  end

  get '/thumbs/:id' do
    photo = photo params[:id]

    if photo.thumbnail_available?
      thumbnail_path = photo.small_thumbnail_path
    else
      thumbnail_path = photo.preview_path
    end

    send_library_file thumbnail_path,
      disposition: :inline,
      filename: 'thumb_%s' % [ photo.file_name ]
  end

end
