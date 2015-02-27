# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Photo < ActiveRecord::Base

  self.inheritance_column = nil
  self.primary_key = 'modelId'
  self.table_name = 'RKVersion'

  has_one :master, class: Gallerist::PhotoMaster, primary_key: 'masterId', foreign_key: 'modelId'
  has_many :album_photos, primary_key: 'modelId', foreign_key: 'versionId'
  has_and_belongs_to_many :albums, through: :album_photos

  alias_attribute :date, :imageDate
  alias_attribute :file_path, :fileName

  def file_name
    File.basename file_path
  end

  def image_path
    File.join "Masters", master.path
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
