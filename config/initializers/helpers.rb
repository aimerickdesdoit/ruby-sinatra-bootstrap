Dir[File.expand_path('../../../app/helpers/*', __FILE__)].each do |helper|
  require helper
end