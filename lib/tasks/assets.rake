namespace :assets do
  
  desc "Compile all the assets"
  task :precompile do
    Rake::Task['assets:clean'].invoke
    Sinatra::Sprockets.precompile_assets! do |asset|
      puts "asset #{asset.logical_path} precompiled"
    end
    Rake::Task['assets:clean'].invoke
  end
  
  desc "Remove compiled assets"
  task :clean do
    rm_rf Sinatra::Sprockets.precompile_path
  end

end