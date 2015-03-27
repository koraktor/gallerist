# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'active_record'
require 'bootstrap-sass'
require 'logger'
require 'sinatra/sprockets-helpers'

class Gallerist::App < Sinatra::Base

  autoload :BaseExtensions, 'gallerist/app/base_extensions'
  autoload :Helpers, 'gallerist/app/helpers'
  autoload :Utilities, 'gallerist/app/utilities'

  register BaseExtensions
  helpers Helpers, Utilities

  register Sinatra::Sprockets::Helpers

  configure do
    enable :logging

    set :root, File.join(root, '..', '..')

    set :library, nil
    set :library_path, ENV['GALLERIST_LIBRARY']
    set :copy_dbs, !ENV['GALLERIST_NOCOPY']
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

  get '/' do
    @title = library.name

    @albums = library.albums.visible.nonempty.order :date
    @persons = library.persons
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

  get '/persons/:id' do
      @person = library.persons.find params[:id]
      @title = @person.name

      navbar_for @person

      erb :person
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
