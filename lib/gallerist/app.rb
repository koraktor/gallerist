# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2016, Sebastian Staudt

require 'active_record'
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

  before '*/full' do
    @full = true
    request.path_info.chomp! '/full'
  end

  before '*/view/:id' do
    @current = params[:id].to_i
    request.path_info.sub! /\/view\/\d+\z/, ''
  end

  error 500 do |error|
    @title = 'Error'

    raise error if env['rack.errors'].is_a? StringIO

    erb :'500'
  end

  get '/' do
    @title = library.name

    @albums = library.albums.visible.nonempty.order(:date).includes :key_photo
    @persons = library.persons.includes key_face: :photo
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

  get '/persons' do
    @persons = library.persons
    @title = 'Persons'

    navbar_for :persons

    erb :persons
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

  get '/tags' do
    @tags = library.tags.nonempty.order 'photos_count desc'
    @title = 'Tags'

    navbar_for :tags

    erb :tags
  end

  get '/tags/:name' do
    if params[:name].include? '+'
      @tag = Gallerist::MultiTag.new library, params[:name].split('+'), true
    elsif params[:name].include? ','
      @tag = Gallerist::MultiTag.new library, params[:name].split(','), false
    else
      @tag = library.tags.find_by_simple_name params[:name]
      not_found if @tag.nil?
    end
    @title = @tag.name

    navbar_for @tag

    erb :tag
  end

  get '/previews/:id' do
    photo = photo params[:id]

    not_found if photo.fullsize_preview_path.nil?

    send_library_file photo.fullsize_preview_path,
      disposition: :inline,
      filename: "preview_#{photo.file_name}"
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
