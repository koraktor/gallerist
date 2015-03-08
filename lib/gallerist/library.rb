# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'sqlite3'

class Gallerist::Library

  attr_reader :app
  attr_reader :name
  attr_reader :path

  def initialize(app, library_path)
    @app = app
    @name = File.basename(library_path).rpartition('.').first
    @path = File.expand_path library_path

    @temp_path = Dir.mktmpdir 'gallerist'
    at_exit { FileUtils.rm_rf @temp_path }

    copy_tmp_db 'Library.apdb'
    copy_tmp_db 'ImageProxies.apdb'

    app.logger.info "Loading library from \"#{@path}\""
  end

  def albums
    Gallerist::Album.all
  end

  def copy_tmp_db(db_name)
    source_path = File.join @path, 'Database', db_name
    dest_path = File.join @temp_path, db_name

    db = SQLite3::Database.new source_path
    db.transaction :immediate do |_|
      FileUtils.cp source_path, dest_path, preserve: true
    end
  ensure
    db.close unless db.nil?
  end

  def tags
    Gallerist::Tag.all
  end

  def library_db
    File.join @temp_path, 'Library.apdb'
  end

  def image_proxies_db
    File.join @temp_path, 'ImageProxies.apdb'
  end

  def inspect
    "#<%s path='%s'>" % [ self.class, path ]
  end

  def photos
    Gallerist::Photo.all
  end

end
