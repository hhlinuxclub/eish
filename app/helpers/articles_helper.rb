module ArticlesHelper
  def cloudify(categories, min_font_size = 100, max_font_size = 140, span_css_style = "display:inline-block;")
    xhtml = ""
    categories_array = Array.new
    
    categories.each do |c|
      categories_array.push(c.articles.count)
    end
    
    categories_array.sort!
    
    min_occurs = categories_array.at(0)
    max_occurs = categories_array.last
    
    categories.each do |c|
      weight = (Math.log(c.articles.count)-Math.log(min_occurs))/(Math.log(max_occurs)-Math.log(min_occurs))
      font_size_of_current_category = (min_font_size + ((max_font_size-min_font_size)*weight)).round
      
      xhtml << "<span style=\"" + span_css_style + "\">"
      xhtml << "#{link_to c.name, categories_path(c), :style => "font-size: " + font_size_of_current_category.to_s + "%"} (" + c.articles.count.to_s + ") &nbsp;"
      xhtml << "</span>"
    end
    
    return xhtml
  end
end
