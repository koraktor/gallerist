# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist

  autoload :App, 'gallerist/app'
  autoload :Helpers, 'gallerist/helpers'
  autoload :Library, 'gallerist/library'
  autoload :LibraryInUseError, 'gallerist/errors'
  autoload :RaiseWarmupExceptions, 'gallerist/middleware/raise_warmup_exceptions'
  autoload :ShowExceptions, 'gallerist/middleware/show_exceptions'

  # Models
  autoload :AdminData, 'gallerist/models/admin_data'
  autoload :Album, 'gallerist/models/album'
  autoload :AlbumPhoto, 'gallerist/models/album_photo'
  autoload :ImageProxiesModel, 'gallerist/models/image_proxies_model'
  autoload :ImageProxyState, 'gallerist/models/image_proxy_state'
  autoload :Master, 'gallerist/models/master'
  autoload :ModelResource, 'gallerist/models/model_resource'
  autoload :Photo, 'gallerist/models/photo'
  autoload :Tag, 'gallerist/models/tag'
  autoload :TagPhoto, 'gallerist/models/tag_photo'

end
