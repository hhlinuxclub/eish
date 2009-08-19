class Admin::HomeController < AdministrationController
  def index
    @role = current_user.role
    @sysinfo = SysInfo.new
    @uptime = seconds_to_human(@sysinfo.uptime*60*60)
    @article_stats = Article.statistics
    @news_stats = News.statistics
    @event_stats = Event.statistics
    @gallery_stats = Gallery.statistics
  end
  
  protected
  
  def seconds_to_human(sec)
    time = sec.round
    seconds = time % 60
    time /= 60
    minutes = time % 60
    time /= 60
    hours = time % 24
    time /= 24
    days = time
    {:days => days, :hours => hours, :minutes => minutes, :seconds => seconds}
  end
end
