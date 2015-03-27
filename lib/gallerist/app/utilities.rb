# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::App::Utilities

  def send_library_file(file, options = {})
    logger.debug "Serving file '%s' from library..." % [ file ]

    file_path = File.join(library.path, file)
    response = catch(:halt) { send_file file_path, options }
    if response == 404
      logger.error "File '%s' could not be served, because it does not exist." % file
    end

    halt response
  end

  def setup_library
    settings.set :library, Gallerist::Library.new(settings.library_path)

    logger.info "Loading library from \"#{library.path}\""

    if settings.copy_dbs
      logger.debug 'Creating temporary copy of the main library database...'
      library.copy_base_db
      logger.debug '  Completed.'
    end

    ActiveRecord::Base.establish_connection({
      adapter: 'sqlite3',
      database: library.library_db
    })
    ActiveRecord::Base.connection.exec_query 'PRAGMA journal_mode="MEMORY";'

    if settings.copy_dbs
      logger.debug 'Creating temporary copies of additional library databases...'
      library.copy_extra_dbs
      logger.debug '  Completed.'
    end

    logger.info "  Found library with type '%s'." % [ library.app_id ]

    Gallerist.load_models
    Gallerist::BaseModel.descendants.each do |model|
      logger.debug "Setting up %s for library type '%s'" % [ model, library.type ]

      model.setup_for library.type
    end

    Gallerist::ImageProxiesModel.establish_connection({
      adapter: 'sqlite3',
      database: library.image_proxies_db
    })
    Gallerist::ImageProxiesModel.connection.exec_query 'PRAGMA journal_mode="MEMORY";'

    Gallerist::PersonModel.establish_connection({
      adapter: 'sqlite3',
      database: library.person_db
    })
    Gallerist::PersonModel.connection.exec_query 'PRAGMA journal_mode="MEMORY";'

    settings.library
  end

  def navbar_item(name, url, *args)
    url = url % args unless args.empty?
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
    when Gallerist::Album
      navbar_item 'Albums', '/albums'
      navbar_item obj.name, '/albums/%d', obj.id
    when Gallerist::Person
      navbar_item 'Persons', '/persons'
      navbar_item obj.name, '/persons/%d', obj.id
    when Gallerist::Tag
      navbar_item 'Tags', '/tags'
      navbar_item obj.name, '/tags/%s', obj.simple_name
    end
  end

  def photo(id)
    Gallerist::Photo.find id
  rescue ActiveRecord::RecordNotFound
    logger.error 'Could not find the photo with ID #%s.' % [ id ]
    not_found
  end

end
