require 'sinatra/sprockets'
require 'compass'

Sinatra::Sprockets.configure do |sprockets|
  Compass::Frameworks::ALL.each do |framework|
    sprockets.environment.append_path framework.stylesheets_directory
  end
end