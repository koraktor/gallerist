# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

module Gallerist::PhotosExtensions::Master

  def __extend
    default_scope { select :fileName, :imagePath, :modelId, :uuid }
  end

end
