# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2019, Sebastian Staudt

module Gallerist::PhotosExtensions::ModelResource

  def __extend
    default_scope { select(:attachedModelType, :modelId, :UTI) }

    alias_attribute :uti, :UTI
  end

  def file_ext
    case uti
      when 'com.apple.quicktime-movie'
        'mov'
      when 'public.jpeg'
        'jpeg'
      when 'public.mpeg-4'
        'mp4'
      else
        nil
    end
  end

end
