# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::PhotoMaster < ActiveRecord::Base

  self.inheritance_column = nil
  self.primary_key = 'modelId'
  self.table_name = 'RKMaster'

  alias_attribute :path, :imagePath

end
