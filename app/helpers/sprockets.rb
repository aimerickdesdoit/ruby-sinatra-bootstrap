module SprocketsHelpers
  
  def stylesheets(files, media = :screen)
    find_assets files, :css do |file|
      <<-HTML
        <link href="#{file}" media="#{media}" rel="stylesheet" type="text/css" />
      HTML
    end
  end

  def javascripts(files)
    find_assets files, :js do |file|
      <<-HTML
        <script src="#{file}" type="text/javascript"></script>
      HTML
    end
  end

  def image_tag(file, options = {})
    options = {:alt => '', :title => ''}.merge(options)
    find_assets file do |file|
      <<-HTML
        <img src="#{file}"#{tag_attributes options} />
      HTML
    end
  end
  
  private
  
  def find_assets(files, extension = nil)
    html = Array(files).collect do |file|
      file = file.to_s
      file << ".#{extension}" if extension && !file.match(/\.#{extension}$/)
      if asset = Sinatra::Sprockets.environment.find_asset(file)
        yield "/assets/#{asset.digest_path}"
      else
        raise "Sprockets don't find asset #{file}"
      end
    end
    html.join("\n")
  end
  
end