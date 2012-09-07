#!/usr/bin/env ruby

require File.expand_path('../app.rb', __FILE__)

map '/assets' do
  run Sinatra::Sprockets.environment
end

map '/' do
  run MyApp
end