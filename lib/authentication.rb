module Authentication
  protected
    def logged_in?
      return !current_user_id.nil?
    end
  
    def current_user
      User.find(current_user_id)
    end
    
    def current_user_id
      session[:user_id]
    end
    
    def login_from_cookie
      return unless cookies[:auth_token] && !logged_in?
      user = User.find_by_remember_token(cookies[:auth_token])
      if user && !user.remember_token_expires.nil? && Time.now < user.remember_token_expires
        session[:user_id] = user.id
      end
    end
    
    def not_logged_in
      redirect_to :root if logged_in?
    end
end