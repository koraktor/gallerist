# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'gallerist'

Gallerist.stdout << "\e]1;Starting Gallerist…\a" if Gallerist.stdout.tty?

warmup do |app|
  error = []
  Gallerist::App.enable :show_exceptions
  Rack::MockRequest.new(app).get '/',
    'rack.errors' => $stderr,
    'rack.warmup' => true,
    'rack.warmup.error' => error
  Gallerist::App.disable :show_exceptions unless Gallerist::App.development?
  raise error.first unless error.empty?

  Rack::MockRequest.new(app).get '/assets/main.css'
  Rack::MockRequest.new(app).get '/assets/main.js'

  if Gallerist.stdout.tty?
    Gallerist.stdout << "\e]1;Gallerist (listening on #{Gallerist.options[:port]})\a"
  end
end

map '/assets' do
  run Gallerist::App.sprockets
end

run Gallerist::App
