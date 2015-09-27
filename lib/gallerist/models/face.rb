# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::Face < Gallerist::PersonModel

  has_one :photo, primary_key: 'imageId', foreign_key: 'uuid'

  def link_size
    100 / size
  end

  def position_x
    center_x * 100
  end

  def position_y
    (1 - center_y - size / 2) * 100
  end

end
