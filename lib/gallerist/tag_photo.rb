# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::TagPhoto < ActiveRecord::Base

  self.primary_key = 'modelId'
  self.table_name = 'RKKeywordForVersion'

  has_one :tag, primary_key: 'keywordId', foreign_key: 'modelId'
  has_one :photo, primary_key: 'versionId', foreign_key: 'modelId'

  alias_attribute :tag_id, :keywordId
  alias_attribute :photo_id, :versionId

  def inspect
    '#<%s tag_id=%d photo_id=%d>' % [ self.class, tag_id, photo_id ]
  end

end
