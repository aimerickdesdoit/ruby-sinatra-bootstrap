#!/usr/bin/env ruby

require File.expand_path('../app', __FILE__)

map Sinatra::Sprockets.assets_map_path do
  run Sinatra::Sprockets.environment
end

map '/' do
  run MyApp
end