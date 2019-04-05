# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

module Gallerist::App::Utilities

  def send_library_file(file, options = {})
    logger.debug "Serving file '#{file}' from library..."

    file_path = File.join(library.path, file)
    response = catch(:halt) { send_file file_path, options }
    if response == 404
      logger.error "File '#{file}' could not be served, because it does not exist."
    end

    halt response
  end

  def setup_library
    library = Gallerist::Library.new settings.library_path
    settings.set :library, library

    logger.info "Loading library from \"#{library.path}\""

    if settings.copy_dbs
      logger.debug 'Creating temporary copy of the main library database...'
      library.copy_base_db
      logger.debug '  Completed.'
    end

    Gallerist::BaseModel.use_library library

    if settings.copy_dbs
      logger.debug 'Creating temporary copies of additional library databases...'
      library.copy_extra_dbs
      logger.debug '  Completed.'
    end

    logger.info "  Found library with type '#{library.type}'."
    logger.debug "    Library’s App ID is '#{library.app_id}'."

    logger.debug 'Setting up models for library type…'
    Gallerist.load_models library.type
    Gallerist::BaseModel.descendants.each do |model|
      model.setup_for library.type
    end

    if library.legacy?
      logger.warn "  Legacy library versions are not fully supported and may cause problems."

      Gallerist::ImageProxiesModel.database = :image_proxies_db
      Gallerist::ImageProxiesModel.use_library library
      Gallerist::PersonModel.database = :person_db
      Gallerist::PersonModel.use_library library
    end

    library
  rescue ActiveRecord::StatementInvalid
    if $!.original_exception.is_a? SQLite3::BusyException
      raise Gallerist::LibraryInUseError, settings.library_path
    end
    raise
  end

  def navbar_item(name, url)
    @navbar << [ url, name ]
  end

  def navbar_for(obj)
    @navbar = []
    navbar_item library.name, '/'

    case obj
    when :all_photos
      navbar_item 'All photos', '/photos'
    when :favorites
      navbar_item 'Favorites', '/favorites'
    when :movies
      navbar_item 'Movies', '/movies'
    when :persons
      navbar_item 'Persons', '/persons'
    when :tags
      navbar_item 'Tags', '/tags'
    when Gallerist::Album
      navbar_item 'Albums', '/albums'
    when Gallerist::Person
      navbar_item 'Persons', '/persons'
    when Gallerist::Tag, Gallerist::MultiTag
      navbar_item 'Tags', '/tags'
    else #ignore
    end

    unless obj.is_a? Symbol
      navbar_item obj.name, url_for(obj)
    end
  end

  def photo(id)
    Gallerist::Photo.find id
  rescue ActiveRecord::RecordNotFound
    logger.error "Could not find the photo with ID ##{id}."
    not_found
  end

  def render_object(type)
    objects = library.send "#{type}s".to_sym
    object = objects.find params[:id]
    @title = object.name

    navbar_for object

    instance_variable_set "@#{type}".to_sym, object

    erb type
  rescue ActiveRecord::RecordNotFound
    not_found
  end

end
