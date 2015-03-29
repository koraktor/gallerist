# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Person

  def self.included(model)
    model.table_name = 'RKFaceName'

    model.has_many :person_photos, primary_key: 'faceKey', foreign_key: 'faceKey'

    model.send :default_scope do
      model.select(:name, :faceKey, :keyVersionUuid).order(:manual_order)
    end
  end

end
