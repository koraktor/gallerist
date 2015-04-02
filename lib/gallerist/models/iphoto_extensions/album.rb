# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Album

  def self.included(model)
    model.scope :projects, -> { model.where(type: 9) }
  end

end
