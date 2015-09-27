# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::IphotoExtensions::Face

  def __extend
    self.table_name = 'RKDetectedFace'

    alias_attribute :source_height, :height
    alias_attribute :source_width, :width
    alias_attribute :top_left_x, :topLeftX
    alias_attribute :top_left_y, :topLeftY
    alias_attribute :top_right_x, :topRightX
    alias_attribute :top_right_y, :topRightY
    alias_attribute :bottom_left_x, :bottomLeftX
    alias_attribute :bottom_left_y, :bottomLeftY
    alias_attribute :bottom_right_x, :bottomRightX
    alias_attribute :bottom_right_y, :bottomRightY
  end

  def bottom_y
    [ bottom_left_y, bottom_right_x ].max
  end

  def center_x
    left_x + (right_x - left_x) / 2
  end

  def center_y
    top_y + (bottom_y - top_y) / 2
  end

  def left_x
    [ top_left_x, bottom_left_x ].min
  end

  def right_x
    [ top_right_x, bottom_right_x ].max
  end

  def size
    [ right_x - left_x, top_y - bottom_y ].max
  end

  def top_y
    [ top_left_y, top_right_y ].min
  end

end
