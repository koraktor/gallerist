# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::Photo

  def self.included(model)
    model.has_one :model_resource, -> { where model_type: 2 }, foreign_key: 'attachedModelId'
    model.has_many :person_photos, primary_key: 'modelId', foreign_key: 'versionId'

    model.alias_attribute :is_favorite, :isFavorite

    model.send :default_scope do
      model.select(:isFavorite, :masterId, :modelId, :fileName, :imageDate, :type, :uuid).
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

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def persons
    Gallerist::Person.where modelId: person_photos.map(&:person_id)
  end

end
