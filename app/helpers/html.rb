module MyAppHelpers
  
  def stylesheets(files, media = :screen)
    assets files, :stylesheets do |file|
      file << '.css' unless file.match(/\.css$/)
      <<-HTML
        <link href="#{url file}" media="#{media}" rel="stylesheet" type="text/css" />
      HTML
    end
  end
  
  def javascripts(files)
    assets files, :javascripts do |file|
      file << '.js' unless file.match(/\.js$/)
      <<-HTML
        <script src="#{file}" type="text/javascript"></script>
      HTML
    end
  end
  
  private
  
  def assets(files, dir)
    files.to_a.collect do |file|
      file = "/assets/#{dir}/#{file}"
      yield file
    end.join("\n")
  end
  
end