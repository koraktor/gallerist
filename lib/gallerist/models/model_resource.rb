# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::ModelResource < Gallerist::ImageProxiesModel

  self.table_name = 'RKModelResource'

  belongs_to :photo

  alias_attribute :file_name, :filename
  alias_attribute :model_type, :attachedModelType
  alias_attribute :uuid, :resourceUuid

  default_scope { select(:attachedModelType, :filename, :modelId, :resourceUuid) }

  def inspect
    "#<#{self.class} id=#{id} uuid=#{uuid} file_name=#{file_name}>"
  end

end
