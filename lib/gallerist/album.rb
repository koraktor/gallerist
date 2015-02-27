# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Album < ActiveRecord::Base

  self.primary_key = 'modelId'
  self.table_name = 'RKAlbum'

  has_many :album_photos, primary_key: 'modelId', foreign_key: 'albumId'
  has_many :photos, through: :album_photos

  alias_attribute :date, :createDate
  alias_attribute :hidden, :isHidden
  alias_attribute :trashed, :isInTrash

  scope :visible, -> { where(trashed: false, hidden: false) }

end
