# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

# Monkey-patch for Sinatra 1.4 and Rack 1.6
#
# See https://github.com/sinatra/sinatra/issues/951
class Gallerist::ShowExceptions < Sinatra::ShowExceptions

  def call(env)
    @app.call(env)
  rescue Exception => e
    raise if env['rack.errors'].is_a? StringIO

    errors, env["rack.errors"] = env["rack.errors"], @@eats_errors

    if prefers_plain_text?(env)
      content_type = "text/plain"
      exception_string = dump_exception(e)
    else
      content_type = "text/html"
      exception_string = pretty(env, e)
    end

    env["rack.errors"] = errors

    # Post 893a2c50 in rack/rack, the #pretty method above, implemented in
    # Rack::ShowExceptions, returns a String instead of an array.
    body = Array(exception_string)

    [
      500,
     {"Content-Type" => content_type,
      "Content-Length" => Rack::Utils.bytesize(body.join).to_s},
     body
    ]
  end

end
