# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Authentication
  include Authorization
  
  def long_date(time)
    return time.strftime("%d %B %Y at %H:%M")
  end
  
  def short_date(time)
    return time.strftime("%d.%m.%Y %H:%M")
  end
  
  def admin_namespace?
    controller.controller_path =~ /admin\// ? true : false
  end
  
  def navigation(*controllers)
    xhtml = String.new
    xhtml << "<ul>\n"
    
    controllers.each do |c|
      if c.downcase == controller.controller_name
        xhtml << "<li class=\"activeLink\">"
      else
        xhtml << "<li>"
      end
      xhtml << link_to(c.capitalize, "/#{c}")
      xhtml << "</li>\n"
    end
    
    xhtml << "</ul>"
  end
  
  def can_edit?(item)
    logged_in? ? item.editable?(current_user) : false
  end
end