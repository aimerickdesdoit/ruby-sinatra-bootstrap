raise 'Capistrano must be configured'

# Enable multi-stage support
require 'capistrano/ext/multistage'

# Bundler
require 'bundler/capistrano'

# Stage definitions
set :stages,        %w(staging production)
set :default_stage, 'staging'

# Deployment environment information
set :application,           'set your application name here'
set :deploy_via,            :remote_cache
set :scm,                   :git
set :scm_verbose,           true
set :repository,            'set your repository location here'
set :git_enable_submodules, 1

# SSH informations
# set :user,      'ssh-user'
# set :use_sudo,  false
# ssh_options[:forward_agent] = true
# ssh_options[:keys]          = "#{ENV['HOME']}/.ssh/a-ssh-key"

# Set up the server
set :deploy_to, 'a path on your server'
assign_main_server = lambda do
  server main_server, :web, :app, :db, :primary => true if exists? :main_server
end
after 'staging', &assign_main_server
after 'production', &assign_main_server

# Addons
%w(assets capistrano_colors).each do |addon|
  require File.expand_path("../deploy/addons/#{addon}", __FILE__)
end

# Tasks
set :normalize_asset_timestamps, false

after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.expand_path('tmp/restart.txt', current_path)}"
  end
end