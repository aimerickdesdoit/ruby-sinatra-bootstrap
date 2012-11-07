begin
  require 'padrino-helpers'
  
  module Padrino::Helpers::AssetTagHelpers

    def asset_path(kind, source)
      if source.to_s.start_with? 'http'
        source
      elsif source.to_s.start_with?('/system/')
        Sinatra::Sprockets.system_path(source.gsub('/system/', ''))
      else
        source = source.to_s
        if [:css, :js].include?(kind) && !source.match(/\.#{kind}$/)
          source << ".#{kind}"
        end
        Sinatra::Sprockets.asset_path(source)
      end
    end

  end
rescue LoadError
end