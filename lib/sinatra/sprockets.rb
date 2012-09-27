module Sinatra
  module Sprockets
    class Configuration
      attr_accessor :precompile, :asset_host
    end
    
    class << self
      
      attr_reader :configuration, :environment
    
      def configure(app_root = nil, &block)
        if app_root
          @app_root = app_root
          @environment = ::Sprockets::Environment.new(@app_root)
          @environment.context_class.class_eval do
            def asset_path(path, options = {})
              Sinatra::Sprockets.asset_path(path)
            end
          end
        end
        raise 'Sprockets environment is not initialized' unless @environment
        @configuration ||= Configuration.new
        yield self
      end
      
      # PATHS
      
      def assets_map_path
        '/assets'
      end

      def asset_path(logical_path)
        if asset = environment.find_asset(logical_path)
          if digest? asset.logical_path
            compute_asset_host "#{assets_map_path}/#{asset.digest_path}"
          else
            path = compute_asset_host "#{assets_map_path}/#{asset.logical_path}"
            "#{path}?#{asset.mtime.to_i}"
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

      def precompile?(logical_path)
        if ['.css', '.js'].include? File.extname(logical_path)
          @configuration.precompile.include? logical_path.to_s
        else
          true
        end
      end
      
      private
      
      def compute_asset_host(path)
        if @configuration.asset_host
          @configuration.asset_host.call path
        else
          path
        end
      end
      
      def digest?(logical_path)
        ['.css', '.js'].include? File.extname(logical_path)
      end
      
    end
  end
end