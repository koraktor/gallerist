# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::BaseModel < ActiveRecord::Base

  self.abstract_class = true

  def self.iphoto(&block)
    store_setup :iphoto, &block
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

end
