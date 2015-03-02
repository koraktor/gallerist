# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Photo < ActiveRecord::Base

  self.inheritance_column = nil
  self.primary_key = 'modelId'
  self.table_name = 'RKVersion'

  has_one :master, class: Gallerist::PhotoMaster, primary_key: 'masterId', foreign_key: 'modelId'
  has_one :model_resource, -> { where model_type: 2 }, class: Gallerist::ModelResource, foreign_key: 'attachedModelId'
  has_many :album_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_and_belongs_to_many :albums, through: :album_photos

  alias_attribute :date, :imageDate
  alias_attribute :file_name, :fileName

  def image_path
    if model_resource
      uuid = model_resource.uuid
      first, second = uuid[0].ord.to_s, uuid[1].ord.to_s

      File.join 'resources', 'modelresources', first, second, uuid, model_resource.file_name
    else
      File.join 'Masters', master.path
    end
  end

  def inspect
    "#{self.class}{uuid: %s, file_name: %s}" % [ uuid, file_name ] 
  end

  def path
    File.dirname master.path
  end

  def thumbnail_file_name
    "#{File.basename file_name, '.*'}.jpg"
  end

  def thumbnail_simple_path
    "Thumbnails/#{path}/#{thumbnail_file_name}"
  end

  def thumbnail_uuid_path
    "Thumbnails/#{path}/#{uuid}/#{thumbnail_file_name}"
  end

  def thumbnail_uuid_thumb_path
    "Thumbnails/#{path}/#{uuid}/thumb_#{thumbnail_file_name}"
  end

end
