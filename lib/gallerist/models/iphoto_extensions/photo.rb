# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

module Gallerist::IphotoExtensions::Photo

  def __extend
    alias_attribute :master_uuid, :masterUuid

    alias_attribute :is_favorite, :isFlagged

    default_scope do
      select(:isFlagged, :masterId, :modelId, :fileName, :imageDate, :uuid).
      where(show_in_library: true)
    end
    scope :movies, -> {
      joins(:master).select('"RKMaster"."type"').
      where('RKMaster.type' => 'VIDT')
    }
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

  def small_thumbnail_path
    File.join 'Thumbnails', image_proxy_state.small_thumbnail_path
  end

  def video?
    master.type == 'VIDT'
  end

end
