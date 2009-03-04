# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ReCaptcha::ViewHelper
  
  def long_date(time)
    return time.strftime("%d %B %Y at %H:%M")
  end
  
  def short_date(time)
    return time.strftime("%d.%m.%Y %H:%M")
  end
  
  def admin_namespace?
    if (controller.controller_path =~ /admin\// )
      return true
    else
      return false
    end
  end
  
  def logged_in?
    return !session[:user_id].nil?
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
      xhtml << link_to(c.capitalize, :controller => "/#{c}")
      xhtml << "</li>\n"
    end
    
    xhtml << "</ul>"
  end
  
  def recaptcha?
    return !(defined? RCC_PUB && RCC_PRIV).nil?
  end
end