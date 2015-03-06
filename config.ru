# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

$LOAD_PATH << File.join(__dir__, 'lib')

warmup { |app| Rack::MockRequest.new(app).get '/' }

require 'gallerist'

map '/assets' do
  run Gallerist::App.sprockets
end

run Gallerist::App
