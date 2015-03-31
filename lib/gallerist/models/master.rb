# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Master < Gallerist::BaseModel

  self.table_name = 'RKMaster'

  alias_attribute :file_name, :fileName
  alias_attribute :path, :imagePath

  def inspect
    "#<#{self.class} id=#{id} uuid=#{uuid} name='#{file_name}'>"
  end

end
