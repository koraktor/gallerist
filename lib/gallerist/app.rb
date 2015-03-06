# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'bootstrap-sass'
require 'logger'
require 'sinatra/activerecord'
require 'sqlite3/database_force_readonly'
require 'sinatra/sprockets-helpers'

class Gallerist::App < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  register Sinatra::Sprockets::Helpers

  configure do
    enable :logging

    set :root, File.join(root, '..', '..')

    set :library_path, ENV['GALLERIST_LIBRARY']
    set :views, File.join(root, 'views')

    set :sprockets, Sprockets::Environment.new(root)

    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.css_compressor = :scss

    configure_sprockets_helpers do |helpers|
      helpers.debug = development?
    end

    Bootstrap.load!
  end

  configure :development do
    set :logging, ::Logger::DEBUG
    sprockets.logger = ::Logger.new($stdout, ::Logger::DEBUG)
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
      settings.set :database, {
        adapter: 'sqlite3',
        database: library.library_db
      }

      Gallerist::ImageProxyState.establish_connection({
        adapter: 'sqlite3',
        database: library.image_proxies_db
      })

      Gallerist::ModelResource.establish_connection({
        adapter: 'sqlite3',
        database: library.image_proxies_db
      })

      logger.debug "  Found #{library.albums.size} albums."
    end
    settings.library
  end

  def photo(id)
    Gallerist::Photo.find id
  rescue ActiveRecord::RecordNotFound
    logger.error 'Could not find the photo with ID #%s.' % [ id ]
    not_found
  end

  def self.setup_default_middleware(builder)
    builder.use Sinatra::ExtendedRack
    builder.use Gallerist::ShowExceptions
    setup_logging builder
  end

  get '/' do
    @title = library.name

    @albums = library.albums.visible.nonempty.order :date
    @tags = library.tags.nonempty.order 'photos_count desc'

    erb :index
  end

  get '/albums/:id' do
    @album = library.albums.find params[:id]
    @title = @album.name

    erb :album
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

    erb :tag
  end

  get '/thumbs/:id' do
    photo = photo params[:id]

    send_library_file photo.small_thumbnail_path,
      disposition: :inline,
      filename: 'thumb_%s' % [ photo.file_name ]
  end

end
