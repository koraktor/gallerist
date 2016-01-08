# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2016, Sebastian Staudt

require 'rubygems/package_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec
task default: :spec

spec = Gem::Specification.load 'gallerist.gemspec'
Gem::PackageTask.new spec do |pkg|
end

# Task to clean the package directory
desc 'Clean package directory'
task :clean do
  FileUtils.rm_rf 'pkg'
end
