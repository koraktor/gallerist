# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Tag < Gallerist::BaseModel

  self.table_name = 'RKKeyword'

  has_many :tag_photos, primary_key: 'modelId', foreign_key: 'keywordId'
  has_many :photos, -> { distinct }, through: :tag_photos

  alias_attribute :simple_name, :searchName

  default_scope { select(:modelId, :name, :searchName) }
  scope :nonempty, -> {
    joins(:tag_photos).
    select('count(RKKeywordForVersion.keywordId) as photos_count').
    group('RKKeywordForVersion.keywordId').
    having('photos_count > 0')
  }

  def inspect
    "#<%s id=%d name='%s'>" % [ self.class, id, name ]
  end

  def to_s
    name
  end

end
