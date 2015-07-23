# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'sqlite3'

class Gallerist::Library

  attr_reader :app
  attr_reader :name
  attr_reader :path

  def initialize(library_path)
    @name = File.basename(library_path).rpartition('.').first
    @path = File.expand_path library_path
    @db_path = File.dirname File.realpath(File.join @path, 'Database', 'Library.apdb')
    @temp_path = Gallerist::App.tempdir
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

  def copy_base_db
    copy_tmp_db 'Library.apdb'
  end

  def copy_extra_dbs
    copy_tmp_db 'ImageProxies.apdb'

    if iphoto?
      copy_tmp_db 'Faces.db'
    else
      copy_tmp_db 'Person.db'
    end
  end

  def copy_tmp_db(db_name)
    source_path = File.join @db_path, db_name
    dest_path = File.join @temp_path, db_name

    db = SQLite3::Database.new source_path
    db.transaction :immediate do |_|
      FileUtils.cp source_path, dest_path, preserve: true
    end
  ensure
    db.close unless db.nil?
  end

  def iphoto?
    app_id == 'com.apple.iPhoto'
  end

  def tags
    Gallerist::Tag.all
  end

  def library_db
    File.join db_path, 'Library.apdb'
  end

  def image_proxies_db
    File.join db_path, 'ImageProxies.apdb'
  end

  def inspect
    "#<#{self.class} path='#{path}'>"
  end

  def person_db
    File.join db_path, iphoto? ? 'Faces.db' : 'Person.db'
  end

  def persons
    Gallerist::Person.all
  end

  def photos
    Gallerist::Photo.all
  end

  def type
    iphoto? ? :iphoto : :photos
  end

  # get all photos that have geolocation attributes
  def all_with_location
    Gallerist::Photo.where("latitude IS NOT NULL")
  end

end
