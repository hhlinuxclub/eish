module Authorization
  class ActiveRecord::Base
    def self.find_all_for_user(user, *args)
      role = user.role
      if role.can_update? || role.can_delete? || role.can_publish? || role.can_administer?
        find(:all, *args)
      else
        find_all_by_user_id(user.id, *args)
      end
    end
    
    def editable?(user)
      user.role.can_update? || user.id == self.user_id
    end
  end
  
  module Filters
    protected
      def authorize
        if logged_in? && current_user.normal_user?
          flash[:error] = "You don't have enough privileges."
          redirect_to :root
        elsif !logged_in?
          flash[:error] = "Please log in with enough privileges."
          session[:original_uri] = request.request_uri
          redirect_to :login
        end
      end
      
      def check_create_privileges
        unless current_user.role.can_create?
          controller = self.class.to_s.demodulize.chomp("Controller")
          flash[:error] = "You don't have enough privileges to add content."
          redirect_to :controller => controller, :action => "index"
        end
      end
      
      def check_for_admin
        unless current_user.role.can_administer?
          flash[:error] = "You do not have enough privileges."
          redirect_to :admin
        end
      end
  end
end
