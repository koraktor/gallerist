# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::PersonPhoto < Gallerist::PersonModel

  def inspect
    "#<#{self.class} person_id=#{person_id} photo_id=#{photo_id}>"
  end

end
