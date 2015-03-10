# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

class Gallerist::RaiseWarmupExceptions

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call env
  rescue Exception
    if env['rack.warmup']
      if $!.is_a? SQLite3::BusyException
        raise Gallerist::LibraryInUseError, Gallerist::App.library_path
      end
    end

    raise $!
  end

end
