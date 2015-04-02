# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Photo

  def self.included(model)
    model.alias_attribute :master_uuid, :masterUuid

    alias_attribute :is_favorite, :isFlagged

    model.send :default_scope do
      model.select(:isFlagged, :masterId, :modelId, :fileName, :imageDate, :uuid).
      where(show_in_library: true)
    end
  end

  def image_path
    File.join 'Masters', master.path
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def person_photos
    Gallerist::PersonPhoto.where master_uuid: master.uuid
  end

  def persons
    Gallerist::Person.where faceKey: person_photos.map(&:person_id)
  end

end
