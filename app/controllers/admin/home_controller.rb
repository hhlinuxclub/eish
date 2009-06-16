class Admin::HomeController < AdministrationController
  def index
    @role = User.find(session[:user_id]).role
  end
end
