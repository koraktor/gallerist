# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

class Gallerist::Person < Gallerist::PersonModel

  alias_attribute :manual_order, :manualOrder

  def inspect
    "#<#{self.class} id=#{id} name='#{name}'>"
  end

  def favorite?
    person_type == 1
  end

  def as_json(*)
    { id: id, name: name }
  end

  def to_s
    name
  end

end
