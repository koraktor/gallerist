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
  rescue Exception => error
    if env['rack.warmup']
      if defined?(SQLite3::BusyException) && error.is_a?(SQLite3::BusyException)
        error = Gallerist::LibraryInUseError.new Gallerist::App.library_path
      end

      env['rack.warmup.error'] << error
      return 500, {}, ''
    end

    raise $!
  end

end
