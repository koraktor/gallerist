# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2019, Sebastian Staudt

module Gallerist::PhotosExtensions::Photo

  def __extend
    has_many :faces, primary_key: 'modelId', foreign_key: 'personId'
    has_one :model_resource, -> { where model_type: 2 }, foreign_key: 'attachedModelId'
    has_many :persons, through: :faces

    alias_attribute :is_favorite, :isFavorite

    default_scope do
      select(:isFavorite, :masterId, :modelId, :fileName, :imageDate, :previewsAdjustmentUuid, :type, :uuid).
      where(show_in_library: true)
    end
    scope :movies, -> { where(type: 8) }
  end

  def image_path
    if model_resource
      id_hex = model_resource.id.to_s 16
      id_prefix = (model_resource.id >> 8).to_s(16).rjust 2, '0'
      file_name = 'fullsizeoutput_%s.%s' % [ id_hex, model_resource.file_ext ]

      File.join 'resources', 'media', 'version', id_prefix, '00', file_name
    else
      File.join 'Masters', master.path
    end
  end

  def small_thumbnail_path
    id_hex = id.to_s 16
    id_prefix = (id >> 8).to_s(16).rjust 2, '0'
    file_name = '%s_thumb_%s.jpg' % [ previews_adjustment_uuid, id_hex ]

    File.join 'resources', 'proxies', 'derivatives', id_prefix, '00', id_hex, file_name
  end

  def video?
    type == 8
  end

end
