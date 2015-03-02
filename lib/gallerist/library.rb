# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Library

  attr_reader :app
  attr_reader :name
  attr_reader :path

  def initialize(app, library_path)
    @app = app
    @name = File.basename(library_path).rpartition('.').first
    @path = File.expand_path library_path

    app.logger.info "Loading library from \"#{@path}\""
  end

  def albums
    Gallerist::Album.all
  end

  def library_db
    File.join @path, 'Database', 'Library.apdb'
  end

  def image_proxies_db
    File.join @path, 'Database', 'ImageProxies.apdb'
  end

  def inspect
    "%s{path: '%s'}" % [ self.class, path ]
  end

end
