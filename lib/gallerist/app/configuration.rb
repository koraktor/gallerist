# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::App::Configuration

  def self.configure(*args, &block)
    Gallerist::App.instance_exec *args, &block
  end

  def self.registered(app)
    configure do
      enable :logging

      set :root, File.join(root, '..', '..')

      set :copy_dbs, !ENV['GALLERIST_NOCOPY']
      set :dump_errors, Proc.new { development? }
      set :library, nil
      set :library_path, ENV['GALLERIST_LIBRARY']
      set :views, File.join(root, 'views')

      Sprockets.register_mime_type 'application/vnd.ms-fontobject', '.eot'
      Sprockets.register_mime_type 'application/x-font-ttf', '.ttf'
      Sprockets.register_mime_type 'application/font-woff', '.woff'

      set :sprockets, Sprockets::Environment.new(root)

      sprockets.append_path File.join(root, 'assets', 'stylesheets')
      sprockets.append_path FontAwesome::Sass.fonts_path
      sprockets.cache = Sprockets::Cache::FileStore.new Dir.tmpdir
      sprockets.css_compressor = :scss

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
  end

end
