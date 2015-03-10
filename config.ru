# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

unless defined? Gallerist
  $LOAD_PATH << File.join(__dir__, 'lib')
  require 'gallerist'
end

warmup do |app|
  Rack::MockRequest.new(app).get '/',
    'rack.errors' => $stderr,
    'rack.warmup' => true
end

map '/assets' do
  run Gallerist::App.sprockets
end

run Gallerist::App
