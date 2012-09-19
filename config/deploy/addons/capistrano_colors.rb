require 'capistrano_colors'

Capistrano::Configuration.new.colorize([
  { :match => /HEAD is now at/, :color => :magenta, :prio => 10 }
])