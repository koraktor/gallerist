# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist

  VERSION = '0.1.0'

  autoload :App, 'gallerist/app'
  autoload :Library, 'gallerist/library'
  autoload :LibraryInUseError, 'gallerist/errors'
  autoload :RaiseWarmupExceptions, 'gallerist/middleware/raise_warmup_exceptions'

  # Models

  MODELS = {}

  def self.model(name, file)
    autoload name, file

    MODELS[name] = file
  end

  def self.load_models
    MODELS.values.each { |file| require file }
  end

  model :AdminData, 'gallerist/models/admin_data'
  model :Album, 'gallerist/models/album'
  model :AlbumPhoto, 'gallerist/models/album_photo'
  model :BaseModel, 'gallerist/models/base_model'
  model :ImageProxiesModel, 'gallerist/models/image_proxies_model'
  model :ImageProxyState, 'gallerist/models/image_proxy_state'
  model :Master, 'gallerist/models/master'
  model :ModelResource, 'gallerist/models/model_resource'
  model :Person, 'gallerist/models/person'
  model :PersonModel, 'gallerist/models/person_model'
  model :PersonPhoto, 'gallerist/models/person_photo'
  model :Photo, 'gallerist/models/photo'
  model :Tag, 'gallerist/models/tag'
  model :TagPhoto, 'gallerist/models/tag_photo'

end
