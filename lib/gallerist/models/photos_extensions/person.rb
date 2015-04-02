# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::Person

  def __extend
    self.table_name = 'RKPerson'

    has_many :person_photos, primary_key: 'modelId', foreign_key: 'personId'

    alias_attribute :person_type, :personType
    alias_attribute :simple_name, :searchName

    default_scope do
      select(:modelId, :name, :representativeFaceId).
      order(person_type: :desc, manual_order: :asc)
    end
  end

end
