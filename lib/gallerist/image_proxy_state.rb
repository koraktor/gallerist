# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::ImageProxyState < ActiveRecord::Base

  self.primary_key = 'modelId'
  self.table_name = 'RKImageProxyState'

  belongs_to :photo

  alias_attribute :photo_id, :versionId
  alias_attribute :small_thumbnail_path, :miniThumbnailPath

  default_scope { select(:miniThumbnailPath, :modelId, :versionId) }

  def inspect
    '#<%s id=%d photo=%s>' % [ self.class, id, photo_id ]
  end

end
