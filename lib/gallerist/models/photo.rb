# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Photo < Gallerist::BaseModel

  self.table_name = 'RKVersion'

  has_one :image_proxy_state, foreign_key: 'versionId'
  has_one :master, primary_key: 'masterId', foreign_key: 'modelId'
  has_one :model_resource, -> { where model_type: 2 }, foreign_key: 'attachedModelId'
  has_many :album_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_many :albums, through: :album_photos
  has_many :tag_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_many :tags, -> { distinct }, through: :tag_photos

  iphoto do
    alias_attribute :master_uuid, :masterUuid

    def person_photos
      Gallerist::PersonPhoto.where master_uuid: master.uuid
    end
  end

  photos do
    has_many :person_photos, primary_key: 'modelId', foreign_key: 'versionId'
  end

  alias_attribute :date, :imageDate
  alias_attribute :file_name, :fileName
  alias_attribute :is_favorite, :isFavorite
  alias_attribute :show_in_library, :showInLibrary

  delegate :thumbnail_available?, to: :image_proxy_state, allow_nil: true

  scope :favorites, -> { where(is_favorite: true) }

  photos do
    default_scope do
      select(:masterId, :modelId, :fileName, :imageDate, :type, :uuid).
      where(show_in_library: true)
    end
  end

  iphoto do
    default_scope do
      select(:masterId, :modelId, :fileName, :imageDate, :uuid).
      where(show_in_library: true)
    end
  end

  def image_path
    if model_resource && !video?
      uuid = model_resource.uuid
      first, second = uuid[0].ord.to_s, uuid[1].ord.to_s

      File.join 'resources', 'modelresources', first, second, uuid, model_resource.file_name
    else
      File.join 'Masters', master.path
    end
  end

  def inspect
    "#<%s id=%d uuid=%s file_name='%s'>" % [ self.class, id, uuid, file_name ]
  end

  def path
    File.dirname master.path
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the persons manually
  photos do
    def persons
      Gallerist::Person.where modelId: person_photos.map(&:person_id)
    end
  end

  iphoto do
    def persons
      Gallerist::Person.where faceKey: person_photos.map(&:person_id)
    end
  end

  def preview_path
    dir_name = File.dirname master.path
    image_name = File.basename(master.path, '.*') + '.jpg'
    File.join 'Previews', dir_name, image_name
  end

  def small_thumbnail_path
    File.join 'Thumbnails', image_proxy_state.small_thumbnail_path
  end

  def video?
    type == 8
  end

end