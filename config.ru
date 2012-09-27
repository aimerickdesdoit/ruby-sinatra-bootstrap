#!/usr/bin/env ruby

require File.expand_path('../app', __FILE__)

if MyAppConf.env == :development
  map Sinatra::Sprockets.assets_map_path do
    run Sinatra::Sprockets.environment
  end
end

map '/' do
  run MyApp
end