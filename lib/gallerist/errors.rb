# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::LibraryInUseError < StandardError

  def initialize(library_path)
    super "The library '#{library_path}' is currently in use."
  end

end
