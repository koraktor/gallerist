# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

module Gallerist::PhotosExtensions::PersonPhoto

  def __extend
    self.table_name = 'RKPersonVersion'

    has_one :person, primary_key: 'personId', foreign_key: 'modelId'
    has_one :photo, primary_key: 'versionId', foreign_key: 'modelId'

    alias_attribute :person_id, :personId
    alias_attribute :photo_id, :versionId
  end

end
