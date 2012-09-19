Capistrano::Configuration.instance.load do

  namespace :assets do
    desc "Precompile and upload all the assets"
    task :precompile do
      environment = "RACK_ENV=#{stage}"
      app_root = File.expand_path('../../../..', __FILE__)
      shell = "ssh" + (ssh_options[:keys] ? " -i #{ssh_options[:keys]}" : '')
      
      `cd #{app_root} && #{environment} rake assets:precompile`
      `rsync -auvz --delete-after -e "#{shell}" #{app_root}/public/assets/ #{user}@#{main_server}:#{shared_path}/assets/`    
      run "rm -rf #{latest_release}/public/assets && ln -s #{shared_path}/assets #{latest_release}/public/assets"
      
      `cd #{app_root} && #{environment} rake assets:clean`
      deploy.restart
    end
  end

  after 'deploy:finalize_update' do
    run "rm -rf #{latest_release}/public/assets && ln -s #{shared_path}/assets #{latest_release}/public/assets"
  end

end