# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2016, Sebastian Staudt

module Gallerist

  VERSION = '0.1.0'

  autoload :App, 'gallerist/app'
  autoload :Library, 'gallerist/library'
  autoload :LibraryInUseError, 'gallerist/errors'
  autoload :LibraryNonExistant, 'gallerist/errors'
  autoload :LoggingInitializationError, 'gallerist/errors'
  autoload :Logging, 'gallerist/logging'
  autoload :MultiTag, 'gallerist/multi_tag'
  autoload :RaiseWarmupExceptions, 'gallerist/middleware/raise_warmup_exceptions'

  OPTIONS = {
          library: ENV['GALLERIST_LIBRARY'],
          port: 9292
  }
  STDOUT = $stdout.dup

  def self.options
    OPTIONS
  end

  def self.stdout
    STDOUT
  end

  # Models

  MODELS = {}

  def self.model(name, file)
    autoload name, "gallerist/models/#{file}"

    MODELS[name] = file
  end

  def self.load_models(library_type)
    MODELS.each_value do |file|
      require "gallerist/models/#{file}"

      begin
        require "gallerist/models/#{library_type}_extensions/#{file}"
      rescue LoadError
        # ignored
      end
    end
  end

  model :AdminData, 'admin_data'
  model :Album, 'album'
  model :AlbumPhoto, 'album_photo'
  model :BaseModel, 'base_model'
  model :Face, 'face'
  model :ImageProxiesModel, 'image_proxies_model'
  model :ImageProxyState, 'image_proxy_state'
  model :Master, 'master'
  model :ModelResource, 'model_resource'
  model :Person, 'person'
  model :PersonModel, 'person_model'
  model :PersonPhoto, 'person_photo'
  model :Photo, 'photo'
  model :Tag, 'tag'
  model :TagPhoto, 'tag_photo'

  module IphotoExtensions; end
  module PhotosExtensions; end

end
