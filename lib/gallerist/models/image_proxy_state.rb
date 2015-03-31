# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::ImageProxyState < Gallerist::ImageProxiesModel

  self.table_name = 'RKImageProxyState'

  belongs_to :photo

  alias_attribute :photo_id, :versionId
  alias_attribute :small_thumbnail_path, :miniThumbnailPath
  alias_attribute :thumbnail_available, :thumbnailsCurrent

  default_scope { select(:miniThumbnailPath, :modelId, :thumbnailsCurrent, :versionId) }

  def inspect
    "#<#{self.class} id=#{id} photo=#{photo_id}>"
  end

end
