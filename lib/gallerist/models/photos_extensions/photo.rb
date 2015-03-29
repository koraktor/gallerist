# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::Photo

  def self.included(model)
    model.has_many :person_photos, primary_key: 'modelId', foreign_key: 'versionId'

    model.send :default_scope do
      model.select(:masterId, :modelId, :fileName, :imageDate, :type, :uuid).
      where(show_in_library: true)
    end
  end

  # ActiveRecord does not support has_many-through associations across
  # different databases, so we have to query the photos manually
  def persons
    Gallerist::Person.where modelId: person_photos.map(&:person_id)
  end

end
