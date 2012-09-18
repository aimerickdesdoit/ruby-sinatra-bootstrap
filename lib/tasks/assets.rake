namespace :assets do
  
  desc "Compile all the assets"
  task :precompile do
    Rake::Task['assets:clean'].invoke
    
    environment = Sinatra::Sprockets.environment
    environment.each_logical_path do |logical_path|
      if Sinatra::Sprockets.precompile? logical_path
        if asset = environment.find_asset(logical_path)
          precompile_path = Sinatra::Sprockets.precompile_path(asset)
          FileUtils.mkdir_p File.dirname(precompile_path)
          asset.write_to precompile_path
          puts "asset #{asset.logical_path} precompiled"
        end
      end
    end
  end
  
  desc "Remove compiled assets"
  task :clean do
    rm_rf Sinatra::Sprockets.precompile_path
  end

end