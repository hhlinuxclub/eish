module ArticlesHelper
  def cloudify(categories)
    xhtml = ""
    
    categories.each do |c|
      articles_count = c.articles.count
      
        if articles_count > 0
          size = 0.7 * Math.log(articles_count)
        else
          size = 0.6 * Math.log(1)
        end

      xhtml << "#{link_to c.name, categories_path(c), :style => "font-size: " + size.to_s + "em"} (" + articles_count.to_s + ")"
    end
    
    return xhtml
  end
  
  def weight(x)
    constant = 0.6;
    
    if x == nil || x==0
      x = 1
    end
    
    return (constant * Math.log(x))
  end
end
