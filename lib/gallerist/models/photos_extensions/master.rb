# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::PhotosExtensions::Master

  def self.included(model)
    model.send :default_scope do
      model.select :fileName, :imagePath, :modelId, :uuid
    end
  end

end
