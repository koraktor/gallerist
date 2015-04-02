# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Person

  def __extend
    self.table_name = 'RKFaceName'

    has_many :person_photos, primary_key: 'faceKey', foreign_key: 'faceKey'

    default_scope do
      select(:modelId, :name, :faceKey, :keyVersionUuid).order(:manual_order)
    end
  end

end
