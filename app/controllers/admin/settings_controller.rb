class Admin::SettingsController < AdministrationController
  before_filter :check_for_admin
  
  def index
    @site_name = Setting.option("site_name")
    @welcome_message = Setting.option("welcome_message")
    @google_analytics_enabled = Setting.option("google_analytics_enabled", :boolean)
    @google_analytics_tracker_id = Setting.option("google_analytics_tracker_id")    
    @https_enabled = Setting.option("https_enabled", :boolean)
    @footer = Setting.option("footer")
    
    set_meta_tags :title => "Settings"
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    settings = params[:settings]
    
    settings.each do |option, value|
      setting = Setting.find_by_option(option)
      setting.value = value
      setting.save if setting.changed?
    end
    
    respond_to do |format|
      flash[:notice] = "Settings saved successfully."
      format.html { redirect_to :controller => "settings" }
    end
  end
end
