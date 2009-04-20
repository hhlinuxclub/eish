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

      xhtml << "#{link_to c.name, categories_path(c), :style => "font-size: " + size.to_s + "em"} (" + articles_count.to_s + ") &nbsp;"
    end
    
    return xhtml
  end
  
  def category_table(categories, id = "category_table", columns = 5)
    xhtml = "<table id=\""+ id + "\">"
    count = 0;
    rows = categories.count/columns 
    total_count = 0;
    
    if categories.count%columns !=0 && categories.count > columns
      rows += 1
    end
    
    extra_cells = (rows * columns) - categories.count
    
    categories.each do |c|
      count = count + 1
      total_count = total_count + 1
      
      if count == 1
        xhtml << "<tr>"
      end
      
      xhtml << "<td>#{link_to c.name, categories_path(c)} (#{c.articles.count.to_s})</td>"
      
      if count == columns && total_count != categories.count
        xhtml << "</tr>"
        count = 0
      end
    end
    
    extra_cells.times do
      xhtml << "<td>&nbsp;</td>"
    end
    
    
    xhtml << "</tr></table>"
    return xhtml
  end
  
  def new_cloudify(categories)
    
  end
end
