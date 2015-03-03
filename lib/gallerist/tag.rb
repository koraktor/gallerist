# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Tag < ActiveRecord::Base

  self.primary_key = 'modelId'
  self.table_name = 'RKKeyword'

  has_many :tag_photos, primary_key: 'modelId', foreign_key: 'keywordId'
  has_many :photos, through: :tag_photos

  alias_attribute :simple_name, :searchName

  scope :nonempty, -> {
    joins(:tag_photos).
    select('RKKeyword.*', 'count(RKKeywordForVersion.keywordId) as photos_count').
    group('RKKeywordForVersion.keywordId').
    having('photos_count > 0')
  }

  def inspect
    "%s{id: %d, name: '%s'}" % [ self.class, id, name ]
  end

  def to_s
    name
  end

end
