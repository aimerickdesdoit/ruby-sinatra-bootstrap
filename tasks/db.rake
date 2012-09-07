namespace :db do
  
  desc "Migrate the database (options: VERSION=x)"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
  end

end