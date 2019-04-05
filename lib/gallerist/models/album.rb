# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Album < Gallerist::BaseModel

  self.table_name = 'RKAlbum'

  has_many :album_photos, primary_key: 'modelId', foreign_key: 'albumId'
  has_one :key_photo, class_name: Gallerist::Photo.to_s, primary_key: 'posterVersionUuid', foreign_key: 'uuid'
  has_many :photos, through: :album_photos

  alias_attribute :date, :createDate
  alias_attribute :hidden, :isHidden
  alias_attribute :trashed, :isInTrash
  alias_attribute :type, :albumType

  default_scope do
    select :albumType, :createDate, :isHidden, :isInTrash, :modelId, :name,
           :posterVersionUuid
  end
  scope :nonempty, -> {
    joins(:album_photos).
    select('count(RKAlbumVersion.albumId) as photos_count').
    group('RKAlbumVersion.albumId').
    having('photos_count > 0')
  }
  scope :regular, -> { where(type: 1) }
  scope :visible, -> { where(trashed: false, hidden: false) }

  def inspect
    "#<#{self.class} id=#{id} name='#{name}'>"
  end

  def key_photo_with_fallback
    key_photo || photos.first
  end

end
