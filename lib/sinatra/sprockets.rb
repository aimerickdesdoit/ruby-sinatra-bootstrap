module Sinatra
  module Sprockets
    class Configuration
      attr_accessor :precompile
    end
    
    class << self
      
      attr_reader :configuration, :environment
    
      def configure(app_root, &block)
        @app_root = app_root
        @environment = ::Sprockets::Environment.new(@app_root)
        @environment.context_class.class_eval do
          def asset_path(path, options = {})
            Sinatra::Sprockets.asset_path(path)
          end
        end
        @configuration = Configuration.new
        yield self
      end
      
      def digest?(logical_path)
        ['.css', '.js'].include? File.extname(logical_path)
      end
      
      # PATHS
      
      def assets_map_path
        '/assets'
      end

      def asset_path(logical_path)
        if asset = environment.find_asset(logical_path)
          if digest? asset.logical_path
            "#{assets_map_path}/#{asset.digest_path}"
          else
            "#{assets_map_path}/#{asset.logical_path}?#{asset.mtime.to_i}"
          end
        else
          raise "Sprockets don't find asset #{logical_path}"
        end
      end
      
      # PRECOMPILE
      
      def precompile_path(asset = nil)
        path = File.expand_path("public/assets", @app_root)
        if asset
          if digest? asset.logical_path
            File.expand_path(asset.digest_path, path)
          else
            File.expand_path(asset.logical_path, path)
          end
        else
          path
        end
      end

      def precompiled?(logical_path)
        if ['.css', '.js'].include? File.extname(logical_path)
          @configuration.precompile.include? logical_path.to_s
        else
          true
        end
      end
            
    end
  end
end