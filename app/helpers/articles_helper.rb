module ArticlesHelper
  def cloudify(categories, min_font_size = 100, max_font_size = 140, link_css_class = "cloudLink title", span_css_style = "display:inline-block;")
    xhtml = ""
    categories_array = Array.new
    
    categories.each do |c|
      count = c.published_articles.count
      categories_array.push count if count > 0
    end
    
    categories_array.sort!
    
    min_occurs = categories_array.first
    max_occurs = categories_array.last
    
    categories.each do |c|
      if c.published_articles.count > 0
        if min_occurs < max_occurs
          weight = (Math.log(c.published_articles.count) - Math.log(min_occurs)) / (Math.log(max_occurs) - Math.log(min_occurs))
          font_size_of_current_category = (min_font_size + ((max_font_size-min_font_size) * weight)).round
        else
          font_size_of_current_category = min_font_size
        end

        xhtml << "<span style=\"" + span_css_style + "\" title=\"#{ pluralize(c.published_articles.count, "article") }\">"
        xhtml << "#{link_to c.name, categories_path(c), :class => link_css_class, :style => "font-size: " + font_size_of_current_category.to_s + "%"} (" + c.published_articles.count.to_s + ") &nbsp;"
        xhtml << "</span>"
      end
    end
    
    return xhtml
  end
end
