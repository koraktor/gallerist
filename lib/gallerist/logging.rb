# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2016, Sebastian Staudt

require 'fileutils'
require 'logger'

module Gallerist::Logging

  def self.access_logger
    @access_logger
  end

  def self.app_logger
    @app_logger
  end

  def self.level=(level)
    access_logger.level = level
    app_logger.level = level
    server_logger.level = level
  end

  def self.prepare
    return if @logging_prepared

    if Gallerist.options[:log_dir]
      @log_dir = File.expand_path Gallerist.options[:log_dir]
      FileUtils.mkdir_p @log_dir

      access_log = create_log 'access_log'
      server_log = create_log 'server_log'
      app_log = create_log 'app_log'

      $stderr.reopen app_log
    else
      access_log = $stdout
      app_log = $stderr
      server_log = File::NULL
    end

    @access_logger = ::Logger.new access_log
    @app_logger = ::Logger.new app_log
    @server_logger = ::Logger.new server_log

    @logging_prepared = true
  end

  def self.server_logger
    @server_logger
  end

  private

  def self.create_log(name)
    log = File.new File.join(@log_dir, name), 'a+'
    log.sync = true
    log
  rescue
    raise Gallerist::LoggingInitializationError, $!
  end

end
