# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

require 'sqlite3'

class Gallerist::Library

  attr_reader :name
  attr_reader :path

  def initialize(library_path)
    @name = File.basename(library_path).rpartition('.').first
    @path = File.expand_path library_path
    check_db
  rescue Errno::ENOENT
    raise Gallerist::LibraryNonExistant, library_path
  end

  def albums
    Gallerist::Album.all
  end

  def app_id
    @app_id ||= Gallerist::AdminData.
      where(propertyArea: 'database', propertyName: 'applicationIdentifier').
      pluck(:propertyValue).first
  end

  def db_path
    @temp_path || @db_path
  end

  def check_db
    main_db_path = file @path, 'Database', 'photos.db'
    @db_path = File.dirname File.realpath(main_db_path)
  rescue
    main_db_path = file @path, 'Database', 'Library.apdb'
    @db_path = File.dirname File.realpath(main_db_path)
    @legacy = true
  end

  def copy_base_db
    copy_tmp_db @legacy ? 'Library.apdb' : 'photos.db'
  end

  def copy_extra_dbs
    return unless @legacy

    copy_tmp_db 'ImageProxies.apdb'
    copy_tmp_db (iphoto? ? 'Faces.db' : 'Person.db')
  end

  def copy_tmp_db(db_name)
    @temp_path ||= Gallerist::App.tempdir
    source_path = file @db_path, db_name
    dest_path = file @temp_path, db_name

    FileUtils.cp source_path, dest_path, preserve: true
  end

  def file(*path_components)
    path = File.expand_path File.join(*path_components)
    Dir.glob(path, File::FNM_CASEFOLD).first || path
  end

  def iphoto?
    app_id == 'com.apple.iPhoto'
  end

  def legacy?
    @legacy
  end

  def library_db
    file db_path, legacy? ? 'Library.apdb' : 'photos.db'
  end

  def image_proxies_db
    file db_path, 'ImageProxies.apdb'
  end

  def inspect
    "#<#{self.class} path='#{path}'>"
  end

  def person_db
    file db_path, iphoto? ? 'Faces.db' : 'Person.db'
  end

  def persons
    Gallerist::Person.all
  end

  def photos
    Gallerist::Photo.all
  end

  def tags
    Gallerist::Tag.all
  end

  def type
    return :iphoto if iphoto?

    legacy? ? :legacy_photos : :photos
  end

end
