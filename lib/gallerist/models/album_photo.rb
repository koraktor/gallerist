# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::AlbumPhoto < Gallerist::BaseModel

  self.table_name = 'RKAlbumVersion'

  has_one :album, primary_key: 'albumId', foreign_key: 'modelId'
  has_one :photo, primary_key: 'versionId', foreign_key: 'modelId'

  alias_attribute :album_id, :albumId
  alias_attribute :photo_id, :versionId

  def inspect
    "#<#{self.class} album_id=#{album_id} photo_id=#{photo_id}>"
  end

end
