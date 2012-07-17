module MyAppHelpers
  
  def stylesheets(files, media = :screen)
    assets files, :stylesheets do |file|
      <<-HTML
        <link href="#{url file}" media="#{media}" rel="stylesheet" type="text/css" />
      HTML
    end
  end
  
  def javascripts(files)
    assets files, :javascripts do |file|
      <<-HTML
        <script src="#{file}" type="text/javascript"></script>
      HTML
    end
  end
  
  private
  
  def assets(files, dir)
    files.collect do |file|
      file = "/assets/#{dir}/#{file}"
      yield file
    end.join("\n")
  end
  
end