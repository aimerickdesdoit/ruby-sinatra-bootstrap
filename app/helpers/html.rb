module HtmlHelpers
  
  private
  
  def tag_attributes(options)
    options.collect do |key, value|
      " #{key}=\"#{value}\"" unless value.nil?
    end
  end
  
end