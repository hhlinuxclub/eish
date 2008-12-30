# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def format_date(time)
    date = time.to_date
    if (date === Date.today)
      return "Today"
    elsif (Date.today - 1 === date)
      return "Yesterday"
    else
      return date.strftime("%d %B %Y")
    end
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
end