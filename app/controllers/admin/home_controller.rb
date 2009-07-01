class Admin::HomeController < AdministrationController
  def index
    @role = current_user.role
  end
end
