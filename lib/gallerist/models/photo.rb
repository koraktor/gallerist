# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Photo < Gallerist::BaseModel

  self.table_name = 'RKVersion'

  has_one :image_proxy_state, foreign_key: 'versionId'
  has_one :master, primary_key: 'masterId', foreign_key: 'modelId'
  has_many :album_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_many :albums, through: :album_photos
  has_many :tag_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_many :tags, -> { distinct }, through: :tag_photos

  alias_attribute :date, :imageDate
  alias_attribute :file_name, :fileName
  alias_attribute :show_in_library, :showInLibrary

  delegate :thumbnail_available?, to: :image_proxy_state, allow_nil: true

  scope :favorites, -> { where(is_favorite: true) }

  def inspect
    "#<#{self.class} id=#{id} uuid=#{uuid} file_name='#{file_name}'>"
  end

  def fullsize_preview_path
    return nil if image_proxy_state.preview_path.nil?

    File.join 'Previews', image_proxy_state.preview_path
  end

  def metadata
    { persons: persons, tags: tags }
  end

  def path
    File.dirname master.path
  end

  def preview_path
    dir_name = File.dirname master.path
    image_name = File.basename(master.path, '.*') + '.jpg'
    File.join 'Previews', dir_name, image_name
  end

  def small_thumbnail_path
    File.join 'Thumbnails', image_proxy_state.small_thumbnail_path
  end

end
