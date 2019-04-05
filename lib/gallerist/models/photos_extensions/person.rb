# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2019, Sebastian Staudt

module Gallerist::PhotosExtensions::Person

  def __extend
    self.table_name = 'RKPerson'

    has_many :faces, primary_key: 'modelId', foreign_key: 'personId'
    has_one :key_face, class_name: Gallerist::Face.to_s, primary_key: 'representativeFaceId', foreign_key: 'modelId'
    has_many :photos, through: :faces

    alias_attribute :person_type, :personType
    alias_attribute :simple_name, :searchName

    default_scope do
      select(:modelId, :name, :representativeFaceId).
      where.not(name: nil).where.not(name: '').
      order(person_type: :desc, manual_order: :asc)
    end
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photo manually
  def key_photo
    key_face.photo
  end

end
