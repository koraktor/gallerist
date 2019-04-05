# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

module Gallerist::PhotosExtensions::Photo

  def __extend
    has_one :model_resource, -> { where model_type: 2 }, foreign_key: 'attachedModelId'
    has_many :person_photos, primary_key: 'modelId', foreign_key: 'versionId'

    alias_attribute :is_favorite, :isFavorite

    default_scope do
      select(:isFavorite, :masterId, :modelId, :fileName, :imageDate, :type, :uuid).
      where(show_in_library: true)
    end
    scope :movies, -> { where(type: 8) }
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

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def persons
    Gallerist::Person.where modelId: person_photos.map(&:person_id)
  end

  def small_thumbnail_path
    File.join 'Thumbnails', image_proxy_state.small_thumbnail_path
  end

  def video?
    type == 8
  end

end
