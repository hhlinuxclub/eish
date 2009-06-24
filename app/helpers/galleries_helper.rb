module GalleriesHelper
  def image_table(collection, columns)
    concat("<table id=\"gallery\">\n")
    collection.each_with_index do |element, index|
      concat("<tr>\n") if index % columns == 0
      concat("<td>\n<div class=\"image\">")
      yield(element)
      concat("</div>\n</td>\n")
      if (index + 1) % columns == 0 || index == collection.count - 1
        concat("</tr>")
      end
    end
    concat("</table>")
  end
end
