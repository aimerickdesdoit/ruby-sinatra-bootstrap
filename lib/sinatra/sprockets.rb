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
              Sinatra::Sprockets.asset_path(path, options)
            end
            
            %w(image video audio font javascript stylesheet).each do |type|
              define_method "#{type}_path" do |path, options|
                asset_path(path, options)
              end
            end
          end
        end
        raise 'Sprockets environment is not initialized' unless @environment
        @configuration ||= Configuration.new
        yield self
        if File.exists?(manifest_path)
          @manifest = YAML.load_file manifest_path
        end
      end
      
      # PATHS
      
      def assets_map_path
        '/assets'
      end

      def asset_path(logical_path, options = {})
        path = if @manifest
          compute_asset_host @manifest[logical_path]
        else
          if asset = environment.find_asset(logical_path, options)
            if digest? asset.logical_path
              compute_asset_host "#{assets_map_path}/#{asset.digest_path}"
            else
              path = compute_asset_host "#{assets_map_path}/#{asset.logical_path}"
              "#{path}?#{asset.mtime.to_i}"
            end
          end
        end
        
        raise "Sprockets doesn't find asset #{logical_path}" unless path
        path
      end
      
      # PRECOMPILE
      
      def precompile_assets!
        manifest = {}
    
        environment.each_logical_path do |logical_path|
          if precompile? logical_path
            if asset = environment.find_asset(logical_path)
              manifest[asset.logical_path] = write_asset(asset)
              yield asset if block_given?
            end
          end
        end
        
        write_manifest manifest
      end
      
      def precompile_path(asset = nil)
        path = File.expand_path("public#{assets_map_path}", @app_root)
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
      
      private

      def precompile?(logical_path)
        if ['.css', '.js'].include? File.extname(logical_path)
          @configuration.precompile.include? logical_path.to_s
        else
          true
        end
      end
      
      def write_asset(asset)
        path = precompile_path(asset)
        FileUtils.mkdir_p File.dirname(path)
        asset.write_to path
        without_compute_asset_host { asset_path asset.logical_path }
      end
      
      # MANIFEST
      
      def manifest_path
        File.expand_path('manifest.yml', precompile_path)
      end
      
      def write_manifest(manifest)
        File.open(manifest_path, 'wb') do |f|
          YAML.dump(manifest, f)
        end
      end
      
      def without_compute_asset_host(&block)
        asset_host = @configuration.asset_host
        @configuration.asset_host = nil
        r = yield
        @configuration.asset_host = asset_host
        r
      end
      
      def compute_asset_host(path)
        if @configuration.asset_host
          @configuration.asset_host.call path
        else
          path
        end
      end
      
      # PATHS
      
      def digest?(logical_path)
        ['.css', '.js'].include? File.extname(logical_path)
      end
      
    end
  end
end