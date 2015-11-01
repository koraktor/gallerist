# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Person < Gallerist::PersonModel

  alias_attribute :manual_order, :manualOrder

  def inspect
    "#<#{self.class} id=#{id} name='#{name}'>"
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def photos
    Gallerist::Photo.where modelId: person_photos.map(&:photo_id)
  end

  def as_json(*)
    { id: id, name: name }
  end

  def to_s
    name
  end

end
