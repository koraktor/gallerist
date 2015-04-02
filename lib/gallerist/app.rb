# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'active_record'
require 'bootstrap-sass'
require 'font-awesome-sass'
require 'logger'
require 'sinatra/sprockets-helpers'

class Gallerist::App < Sinatra::Base

  autoload :BaseExtensions, 'gallerist/app/base_extensions'
  autoload :Configuration, 'gallerist/app/configuration'
  autoload :Helpers, 'gallerist/app/helpers'
  autoload :Utilities, 'gallerist/app/utilities'

  register BaseExtensions, Sinatra::Sprockets::Helpers, Configuration
  helpers Helpers, Utilities

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
    render_object :album
  end

  get '/favorites' do
    @photos = library.photos.favorites
    @title = 'Favorites'

    navbar_for :favorites

    erb :photos
  end

  get '/movies' do
    @photos = library.photos.movies
    @title = 'Movies'

    navbar_for :movies

    erb :photos
  end

  get '/persons/:id' do
    render_object :person
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
      filename: "thumb_#{photo.file_name}"
  end

end
