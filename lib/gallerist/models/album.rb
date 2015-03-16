# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Album < Gallerist::BaseModel

  self.table_name = 'RKAlbum'

  has_many :album_photos, primary_key: 'modelId', foreign_key: 'albumId'
  has_many :photos, through: :album_photos

  alias_attribute :date, :createDate
  alias_attribute :hidden, :isHidden
  alias_attribute :trashed, :isInTrash

  default_scope { select(:createDate, :isHidden, :isInTrash, :modelId, :name) }
  scope :nonempty, -> {
    joins(:album_photos).
    select('count(RKAlbumVersion.albumId) as photos_count').
    group('RKAlbumVersion.albumId').
    having('photos_count > 0')
  }
  scope :visible, -> { where(trashed: false, hidden: false) }

  def inspect
    "#<%s id=%d uuid=%s name='%s'>" % [ self.class, id, uuid, name ]
  end

end
