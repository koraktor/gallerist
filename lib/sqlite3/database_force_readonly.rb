# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'sqlite3'

module SQLite3::DatabaseForceReadonly

  def new(file, options = {})
    options.merge! readonly: true

    orig_new file, options
  end

end

class << SQLite3::Database
  alias_method :orig_new, :new
end

SQLite3::Database.extend SQLite3::DatabaseForceReadonly
