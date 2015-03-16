# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Person < Gallerist::PersonModel

  iphoto do
    self.table_name = 'RKFaceName'

    has_many :person_photos, primary_key: 'faceKey', foreign_key: 'faceKey'

    default_scope { select(:name, :faceKey, :keyVersionUuid).order(:manual_order) }
  end

  photos do
    self.table_name = 'RKPerson'

    has_many :person_photos, primary_key: 'modelId', foreign_key: 'personId'

    alias_attribute :person_type, :personType
    alias_attribute :simple_name, :searchName

    default_scope do
      select(:modelId, :name, :representativeFaceId).
      order(person_type: :desc, manual_order: :asc)
    end
  end

  alias_attribute :manual_order, :manualOrder

  def inspect
    "#<%s id=%d name='%s'>" % [ self.class, id, name ]
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def photos
    Gallerist::Photo.where modelId: person_photos.map(&:photo_id)
  end

  def to_s
    name
  end

end
