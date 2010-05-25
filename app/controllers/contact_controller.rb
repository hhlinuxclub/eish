class ContactController < ApplicationController
  before_filter :check_form, :only => :send_email
  before_filter :require_https if HTTPS_ENABLED
  
  def index
    @contacts = User.find_all_by_contactable(true)
  end
  
  def send_email
    recipient = User.find(params[:user][:user_id]).email
    user = logged_in? ? current_user : User.new(:first_name => params[:name], :email => params[:email])
    
    respond_to do |format|
      if Mailer.deliver_contact(recipient, user, params[:subject], params[:message], request.remote_ip, request.env["HTTP_USER_AGENT"])
        flash[:notice] = "Your email was sent successfully."
      else
        flash[:error] = "We weren't able to send your email. Please try again later."
      end
      format.html { redirect_to :controller => "contact" }
    end
  end
  
  protected
  
  def check_form
    if !logged_in?
      email_reg = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i 
      valid_email = email_reg.match(params[:email])? true : false
      empty_name = params[:name].empty?
      is_bot = params[:are_you_a_computer]
    else
      valid_email = true
      empty_name = false
      is_bot = false
    end
    
    empty_subject = params[:subject].empty?
    empty_message =  params[:message].empty?
    
    if !valid_email || empty_name || empty_subject || empty_message || is_bot
      flash[:error] = "Your message could not be sent."
      respond_to do |format|
        format.html { redirect_to :controller => "contact" }
      end
    end
  end
end
