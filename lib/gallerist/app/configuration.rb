# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'bootstrap-sass'
require 'jquery-cdn'

module Gallerist::App::Configuration

  def self.configure(*envs, &block)
    if envs.empty? || envs.include?(Gallerist::App.environment.to_sym)
      Gallerist::App.instance_exec &block
    end
  end

  def self.registered(app)
    configure do
      set :logging, ENV['VERBOSE'] ? ::Logger::WARN : ::Logger::INFO

      tempdir = Dir.mktmpdir('gallerist')
      at_exit { FileUtils.rm_rf tempdir }

      set :root, File.join(root, '..', '..')
      set :tempdir, tempdir.dup

      set :copy_dbs, !ENV['GALLERIST_NOCOPY']
      set :dump_errors, Proc.new { development? }
      set :library, nil
      set :library_path, ENV['GALLERIST_LIBRARY']
      set :views, File.join(root, 'views')

      Sprockets.register_mime_type 'application/vnd.ms-fontobject', '.eot'
      Sprockets.register_mime_type 'application/x-font-ttf', '.ttf'
      Sprockets.register_mime_type 'application/font-woff', '.woff'

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

      debug_logger = ::Logger.new($stdout, ::Logger::DEBUG)

      sprockets.logger = debug_logger
      ActiveRecord::Base.logger = debug_logger
    end

    configure :production do
      sprockets.css_compressor = :scss
      sprockets.js_compressor = :uglifier
    end
  end

end
