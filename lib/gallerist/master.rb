# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Master < ActiveRecord::Base

  self.inheritance_column = nil
  self.primary_key = 'modelId'
  self.table_name = 'RKMaster'

  alias_attribute :file_name, :fileName
  alias_attribute :path, :imagePath

  default_scope { select(:fileName, :imagePath, :modelId, :type, :uuid) }

  def inspect
    "%s{id: %d, uuid: %s, name: '%s'}" % [ self.class, id, uuid, file_name ]
  end

end
