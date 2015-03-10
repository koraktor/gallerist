# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist

  autoload :AdminData, 'gallerist/admin_data'
  autoload :Album, 'gallerist/album'
  autoload :AlbumPhoto, 'gallerist/album_photo'
  autoload :App, 'gallerist/app'
  autoload :Helpers, 'gallerist/helpers'
  autoload :ImageProxiesModel, 'gallerist/image_proxies_model'
  autoload :ImageProxyState, 'gallerist/image_proxy_state'
  autoload :Tag, 'gallerist/tag'
  autoload :TagPhoto, 'gallerist/tag_photo'
  autoload :Library, 'gallerist/library'
  autoload :LibraryInUseError, 'gallerist/errors'
  autoload :Master, 'gallerist/master'
  autoload :ModelResource, 'gallerist/model_resource'
  autoload :Photo, 'gallerist/photo'
  autoload :RaiseWarmupExceptions, 'gallerist/middleware/raise_warmup_exceptions'
  autoload :ShowExceptions, 'gallerist/middleware/show_exceptions'

end
