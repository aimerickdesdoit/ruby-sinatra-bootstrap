#!/usr/bin/env ruby

require File.expand_path('../config/application.rb', __FILE__)

require 'logger'
require 'sinatra/reloader'

class MyApp < Sinatra::Base
  
  register Sinatra::Reloader
  
  helpers MyAppHelpers
  
  set({
    :show_exceptions  => (environment == :development),
    :public_folder    => "#{root}/public",
    :views            => "#{root}/app/views"
  })

  class << self
    
    def logger
      if MyApp.environment == :development
        Logger.new(STDERR)
      else
        Logger.new(File.expand_path('../log/%s.log', __FILE__) % MyApp.environment)
      end
    end
    
  end

  before do
    content_type :json, :default => true
    @json = {
      :environment => MyApp.environment
    }
  end

  error Sinatra::NotFound do
    @json[:message] = "No entry point for #{request.path_info}"
    MyApp.logger.error @json[:message]
    @json.to_json
  end

  error do
    @json[:message] = "Internal Server Error : #{request.env['sinatra.error'].message}"
    MyApp.logger.error request.env['sinatra.error']
    @json.to_json
  end
  
  get '/' do
    @json[:message] = 'Hello world !'
    @json.to_json
  end
  
end