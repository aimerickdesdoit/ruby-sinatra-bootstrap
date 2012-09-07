require 'active_record'

dbconfig = YAML::load(File.open(File.expand_path('../../database.yml', __FILE__)))

ActiveRecord::Base.establish_connection(dbconfig[APP_ENV.to_s])
ActiveRecord::Base.mass_assignment_sanitizer = :strict

Dir[File.expand_path('../../../app/models/**/*.rb', __FILE__)].each do |file|
  require file
end