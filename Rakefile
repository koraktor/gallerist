# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'rubygems/package_task'

spec = Gem::Specification.load 'gallerist.gemspec'
Gem::PackageTask.new spec do |pkg|
end

# Task to clean the package directory
desc 'Clean package directory'
task :clean do
  FileUtils.rm_rf 'pkg'
end
