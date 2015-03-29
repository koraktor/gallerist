# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::PersonPhoto

  def self.included(model)
    model.table_name = 'RKPersonVersion'

    model.has_one :person, primary_key: 'personId', foreign_key: 'modelId'
    model.has_one :photo, primary_key: 'versionId', foreign_key: 'modelId'

    model.alias_attribute :person_id, :personId
    model.alias_attribute :photo_id, :versionId
  end

end
