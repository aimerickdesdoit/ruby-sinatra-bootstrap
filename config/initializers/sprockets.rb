require 'sinatra/sprockets'

Sinatra::Sprockets.configure(File.expand_path('../../../', __FILE__)) do |sprockets|
  configuration, environment = sprockets.configuration, sprockets.environment
  
  configuration.precompile = ['application.css']
  
  environment.append_path 'app/assets/images'
  environment.append_path 'app/assets/javascripts'
  environment.append_path 'app/assets/stylesheets'
  Compass::Frameworks::ALL.each do |framework|
    environment.append_path framework.stylesheets_directory
  end
end