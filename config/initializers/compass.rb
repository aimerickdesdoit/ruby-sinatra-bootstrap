require 'sinatra/sprockets'
require 'compass'

Compass.configuration.environment = (MyAppConf.env == :development) ? :development : :production

Sinatra::Sprockets.configure do |sprockets|
  Compass::Frameworks::ALL.each do |framework|
    sprockets.environment.append_path framework.stylesheets_directory
  end
end

# Sprocket's Compass options support in Sprockets::Sass::SassTemplate
Compass.add_project_configuration(File.expand_path('../../compass.rb', __FILE__))