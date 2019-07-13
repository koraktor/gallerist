# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2019, Sebastian Staudt

$LOAD_PATH << File.join(__dir__, 'lib')

require 'gallerist'

Gem::Specification.new do |s|
  s.name        = 'gallerist'
  s.version     = Gallerist::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Sebastian Staudt' ]
  s.email       = [ 'koraktor@gmail.com' ]
  s.homepage    = 'https://github.com/koraktor/gallerist'
  s.license     = 'BSD'
  s.summary     = 'A web application to browse Apple Photos and iPhoto libraries'
  s.description = 'View Photos and iPhoto libraries in your browser'

  s.add_dependency 'activerecord', '~> 5.2.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3'
  s.add_dependency 'font-awesome-sass', '~> 4.3'
  s.add_dependency 'jquery-cdn', '~> 2.1'
  s.add_dependency 'puma', '~> 4.0'
  s.add_dependency 'rack', '~> 1.6'
  s.add_dependency 'sinatra', '~> 1.4', '>= 1.4.6'
  s.add_dependency 'sprockets-helpers', '~> 1.1'
  s.add_dependency 'sqlite3', '~> 1.4.0'
  s.add_dependency 'uglifier', '~> 3.0'

  s.executables   = [ 'gallerist' ]
  s.files         = `git ls-files`.split
  s.require_paths = 'lib'
end
