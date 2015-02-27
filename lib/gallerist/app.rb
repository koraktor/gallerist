# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'logger'
require 'sinatra/activerecord'

require 'gallerist/library'
require 'gallerist/helpers'
require 'gallerist/middleware/show_exceptions'

class Gallerist::App < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure do
    enable :logging

    set :views, File.join(settings.root, '..', '..', 'views')
  end

  configure :development do
    set :logging, ::Logger::DEBUG
  end

  helpers Gallerist::Helpers

  def library
    unless settings.respond_to? :library
      settings.set :library, Gallerist::Library.new(self, settings.library_path)
      settings.set :database, {
        adapter: 'sqlite3',
        database: settings.library.database_path
      }

      logger.debug "  Found #{library.albums.size} albums."
    end
    settings.library
  end

  def self.setup_default_middleware(builder)
    builder.use Sinatra::ExtendedRack
    builder.use Gallerist::ShowExceptions
    setup_logging    builder
  end

  get '/' do
    @albums = library.albums.visible.order :date
    @title = library.name

    erb :index
  end

  get '/albums/:id' do
    @album = library.albums.find params[:id]
    @title = @album.name

    erb :album
  end

  get '/photos/:id' do
    photo = Gallerist::Photo.find params[:id]

    send_file File.join(library.path, photo.image_path)
  end

  get '/thumbs/:id' do
    photo = Gallerist::Photo.find params[:id]

    candidates = []
    candidates << photo.thumbnail_uuid_thumb_path
    candidates << photo.thumbnail_uuid_path
    candidates << photo.thumbnail_simple_path

    send_file candidates.map { |path| File.join library.path, path }.
                  find { |path| File.exists? path }
  end

end
