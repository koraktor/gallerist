# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015-2016, Sebastian Staudt

require 'bootstrap-sass'
require 'jquery-cdn'

module Gallerist::App::Configuration

  def self.configure(*envs, &block)
    if envs.empty? || envs.include?(Gallerist::App.environment.to_sym)
      Gallerist::App.instance_exec &block
    end
  end

  def self.registered(_)
    configure do
      set :logging, ENV['VERBOSE'] ? ::Logger::WARN : ::Logger::INFO

      tempdir = Dir.mktmpdir('gallerist')
      at_exit { FileUtils.rm_rf tempdir }

      set :root, File.join(root, '..', '..')
      set :tempdir, tempdir.dup

      set :copy_dbs, !Gallerist.options[:nocopy]
      set :dump_errors, Proc.new { development? }
      set :library, nil
      set :library_path, Gallerist.options[:library]
      set :views, File.join(root, 'views')

      set :sprockets, Sprockets::Environment.new(root)

      sprockets.append_path File.join(root, 'assets', 'javascript')
      sprockets.append_path File.join(root, 'assets', 'stylesheets')
      sprockets.append_path FontAwesome::Sass.fonts_path
      sprockets.cache = Sprockets::Cache::FileStore.new tempdir

      JqueryCdn.install sprockets

      Bootstrap.load!

      configure_sprockets_helpers do |helpers|
        helpers.debug = development?
      end
    end

    configure :development do
      set :logging, ::Logger::DEBUG

      sprockets.logger = Gallerist::Logging.app_logger
      ActiveRecord::Base.logger = Gallerist::Logging.app_logger
    end

    configure :production do
      sprockets.css_compressor = :scss
      sprockets.js_compressor = :uglifier
    end
  end

end
