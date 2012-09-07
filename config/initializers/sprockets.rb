require 'sinatra/sprockets'

Sinatra::Sprockets.configure(File.expand_path('../../../', __FILE__)) do |environment|
  environment.append_path 'app/assets/images'
  environment.append_path 'app/assets/javascripts'
  environment.append_path 'app/assets/stylesheets'
end