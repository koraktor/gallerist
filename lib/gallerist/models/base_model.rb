# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::BaseModel < ActiveRecord::Base

  class << self
    attr_accessor :database
  end

  self.abstract_class = true
  self.database = :library_db
  self.inheritance_column = nil
  self.primary_key = 'modelId'

  def self.iphoto(&block)
    store_setup :iphoto, &block
  end

  def self.journal_mode(mode)
    connection.exec_query 'PRAGMA journal_mode="%s";' % [ mode ]
  end

  def self.photos(&block)
    store_setup :photos, &block
  end

  def self.setup_for(app)
    ((@setups || {})[app] || []).each do |setup|
      setup.call
    end
  end

  def self.store_setup(app, &block)
    @setups ||= {}
    @setups[app] ||= []
    @setups[app] << block
  end

  def self.use_library(library)
    database = library.send self.database
    establish_connection adapter: 'sqlite3', database: database
    journal_mode 'MEMORY'
  end

end
