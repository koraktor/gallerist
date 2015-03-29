# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::Person

  def self.included(model)
    model.table_name = 'RKPerson'

    model.has_many :person_photos, primary_key: 'modelId', foreign_key: 'personId'

    model.alias_attribute :person_type, :personType
    model.alias_attribute :simple_name, :searchName

    model.send :default_scope do
      model.select(:modelId, :name, :representativeFaceId).
      order(person_type: :desc, manual_order: :asc)
    end
  end

end
