# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::AdminData < ActiveRecord::Base

  self.primary_key = 'modelId'
  self.table_name = 'RKAdminData'

end
