# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

require 'unicorn'

module Rack::Handler::Unicorn

    class << self

      def run(app, options = {})
        environment = ENV['RACK_ENV'] || 'development'
        default_host = (environment == 'development') ? 'localhost' : '0.0.0.0'
        options[:Host] ||= default_host
        options[:Port] ||= 9292

        unicorn_options = {
          listeners: [ '%s:%d' % [ options[:Host], options[:Port] ] ]
        }

        ::Unicorn::Launcher.daemonize!(unicorn_options) if options[:daemonize]
        ::Unicorn::HttpServer.new(app, unicorn_options).start.join
      end

      def environment
        ENV['RACK_ENV']
      end

    end

end

Rack::Handler.register :unicorn, Rack::Handler::Unicorn
