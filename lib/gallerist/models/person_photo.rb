# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::PersonPhoto < Gallerist::PersonModel

  iphoto do
    self.primary_key = 'modelId'
    self.table_name = 'RKDetectedFace'

    has_one :person, primary_key: 'faceKey', foreign_key: 'faceKey'

    alias_attribute :master_uuid, :masterUuid
    alias_attribute :person_id, :faceKey

    def photo
      Gallerist::Photo.find_by master_uuid: master_uuid
    end

    def photo_id
      photo.id
    end
  end

  photos do
    self.primary_key = 'modelId'
    self.table_name = 'RKPersonVersion'

    has_one :person, primary_key: 'personId', foreign_key: 'modelId'
    has_one :photo, primary_key: 'versionId', foreign_key: 'modelId'

    alias_attribute :person_id, :personId
    alias_attribute :photo_id, :versionId
  end

  def inspect
    '#<%s person_id=%d photo_id=%s>' % [ self.class, person_id, photo_id ]
  end

end
