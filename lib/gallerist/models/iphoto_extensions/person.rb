# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Person

  def __extend
    self.table_name = 'RKFaceName'

    has_one :key_face, class_name: Gallerist::Face, primary_key: 'faceKey', foreign_key: 'faceKey'
    has_one :key_photo, class_name: Gallerist::Photo, primary_key: 'keyVersionUuid', foreign_key: 'uuid'
    has_many :person_photos, primary_key: 'faceKey', foreign_key: 'faceKey'

    default_scope do
      select(:modelId, :name, :faceKey, :keyVersionUuid).order(:manual_order)
    end
  end

end
