# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::LibraryInUseError < StandardError

  def initialize(library_path)
    super "The library '#{library_path}' is currently in use."
  end

end

class Gallerist::LibraryNonExistant < StandardError

  def initialize(library_path)
    super "The path '#{library_path}' does not exist."
  end

end

class Gallerist::LoggingInitializationError < StandardError

  def initialize(error)
    super 'Logging could not be initialized: %s' % [ error.message ]
  end

  def short_message
    if cause.is_a? Errno::EACCES
      'No permission'
    else
      cause.message
    end
  end

end
