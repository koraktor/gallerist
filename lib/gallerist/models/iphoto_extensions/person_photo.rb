# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::PersonPhoto

  def __extend
    self.table_name = 'RKDetectedFace'

    has_one :person, primary_key: 'faceKey', foreign_key: 'faceKey'

    alias_attribute :master_uuid, :masterUuid
    alias_attribute :person_id, :faceKey
  end

  def photo
    Gallerist::Photo.find_by master_uuid: master_uuid
  end

  def photo_id
    photo.id
  end

end
