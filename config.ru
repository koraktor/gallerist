# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

$LOAD_PATH << 'lib'

require 'gallerist'
require 'gallerist/app'

Gallerist::App.set :library_path, ENV['GALLERIST_LIBRARY']

warmup { |app| Rack::MockRequest.new(app).get '/' }

run Gallerist::App
