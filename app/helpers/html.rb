module MyAppHelpers
  
  def stylesheets(files, media = :screen)
    assets files, :css do |file|
      <<-HTML
        <link href="#{url file}" media="#{media}" rel="stylesheet" type="text/css" />
      HTML
    end
  end
  
  def javascripts(files)
    assets files, :js do |file|
      <<-HTML
        <script src="#{file}" type="text/javascript"></script>
      HTML
    end
  end
  
  private
  
  def assets(files, extension)
    html = Array(files).collect do |file|
      file = file.to_s
      file << ".#{extension}" unless file.match(/\.#{extension}$/)
      if asset = Sinatra::Sprockets.environment.find_asset(file)
        yield "/assets/#{asset.digest_path}"
      else
        raise "Sprockets don't find asset #{file}"
      end
    end
    html.join("\n")
  end
  
end