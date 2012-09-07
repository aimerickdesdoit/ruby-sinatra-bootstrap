module Sinatra
  
  module Sprockets
    
    def self.configure(app_root, &block)
      @app_root = app_root
      @environment = ::Sprockets::Environment.new(@app_root)
      yield @environment
    end

    def self.precompile_path
      @precompiled_path ||= File.expand_path('public/assets', @app_root)
    end
    
    def self.assets_url
      '/assets'
    end

    def self.environment
      @environment
    end
    
  end
  
end