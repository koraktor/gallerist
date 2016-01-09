# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2016, Sebastian Staudt

require 'active_record'
require 'rspec/active_model/mocks'

require 'coveralls'
Coveralls.wear!

require 'gallerist'
include Gallerist

RSpec.configure do |config|
  config.formatter = :documentation
end
