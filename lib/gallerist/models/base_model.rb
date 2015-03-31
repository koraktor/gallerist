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

  def self.journal_mode(mode)
    connection.exec_query "PRAGMA journal_mode='#{mode}';"
  end

  def self.setup_for(app)
    extensions = Gallerist.const_get "#{app.capitalize}Extensions"
    class_name = name.demodulize
    if extensions.const_defined? class_name
      include extensions.const_get class_name
    end
  end

  def self.use_library(library)
    database = library.send self.database
    establish_connection adapter: 'sqlite3', database: database
    journal_mode 'MEMORY'
  end

end
