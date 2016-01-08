# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2016, Sebastian Staudt

class Gallerist::MultiTag

  def initialize(library, tags, intersect)
    @intersect = intersect
    @library = library
    @tags = library.tags.where(simple_name: tags)
  end

  def name
    @tags.map(&:name).join(@intersect ? ' & ' : ', ')
  end

  def photos
    photos = @library.photos.distinct.joins(:tag_photos)
            .where(RKKeywordForVersion: { keywordId: @tags.map(&:id) })

    if @intersect
      unique_tags = Gallerist::TagPhoto.select(:modelId)
              .group(:keywordId, :versionId)
      photos = photos.where(RKKeywordForVersion: { modelId: unique_tags })
              .group(:versionId)
              .having('count(versionId) = ?', @tags.size)
    end

    photos
  end

  def simple_name
    @tags.map(&:simple_name).join(@intersect ? '+' : ',')
  end

end
