#!/usr/bin/env ruby

require File.expand_path('../config/application', __FILE__)

require 'logger'
require 'sinatra/reloader' if MyAppConf.env == :development

class MyApp < Sinatra::Base
  
  # configure
  
  configure :development do
    register Sinatra::Reloader
    also_reload File.expand_path('app/helpers/*', root)
    also_reload File.expand_path('app/models/*', root)
  end
  
  configure do
    register Padrino::Helpers
    # register Padrino::Mailer
    
    set({
      # :show_exceptions  => false, # test error handling
      :environment      => MyAppConf.env,
      :public_folder    => "#{root}/public",
      :views            => "#{root}/app/views",
      :haml             => {
        :format => :html5,
        :layout => 'layouts/default'.to_sym,
        :attr_wrapper => '"'
      }
    })
  end
  
  # logger
  
  def self.logger
    @logger ||= if development?
      Logger.new(STDERR)
    else
      Logger.new(File.expand_path('log/%s.log', root) % environment)
    end
  end
  
  def logger
    self.class.logger
  end
  
  # error handling

  error Sinatra::NotFound do
    @message = "No entry point for #{request.path_info}"
    logger.error @message
    haml 'errors/404'.to_sym
  end

  error do
    @message = "Internal Server Error : #{request.env['sinatra.error'].message}"
    logger.error request.env['sinatra.error']
    haml 'errors/500'.to_sym
  end
  
  # controllers
  
  get '/' do
    haml :index
  end
  
end