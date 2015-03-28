# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::App::BaseExtensions

  def setup_default_middleware(builder)
    builder.use Sinatra::ExtendedRack
    builder.use Sinatra::ShowExceptions if development?
    builder.use Gallerist::RaiseWarmupExceptions

    setup_logging builder
  end

end
