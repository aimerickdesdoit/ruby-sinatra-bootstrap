module SprocketsHelpers
  
  def stylesheets(files, media = :screen)
    asset_path files, :css do |file|
      <<-HTML
        <link href="#{file}" media="#{media}" rel="stylesheet" type="text/css" />
      HTML
    end
  end

  def javascripts(files)
    asset_path files, :js do |file|
      <<-HTML
        <script src="#{file}" type="text/javascript"></script>
      HTML
    end
  end

  def image_tag(file, options = {})
    options = {:alt => '', :title => ''}.merge(options)
    asset_path file do |file|
      <<-HTML
        <img src="#{file}"#{tag_attributes options} />
      HTML
    end
  end

  def image_path(file)
    Sinatra::Sprockets.asset_path(file)
  end
  
  private
  
  def asset_path(files, extension = nil)
    html = Array(files).collect do |file|
      file = file.to_s
      file << ".#{extension}" if extension && !file.match(/\.#{extension}$/)
      yield Sinatra::Sprockets.asset_path(file)
    end
    html.join("\n")
  end
  
end