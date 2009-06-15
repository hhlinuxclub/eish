class ContactController < ApplicationController
  before_filter :check_form, :only => :send_email
  
  def index
    @contacts = User.find_all_by_contactable(true)
    
    set_meta_tags :title => "Contact",
                  :description => "Contact somebody at HHLinuxClub",
                  :keywords => "contact"
  end
  
  def send_email
    recipient = User.find(params[:user][:user_id]).email
    logged_in = !session[:user_id].nil?
    user = logged_in ? User.find(session[:user_id]) : User.new(:first_name => params[:name], :email => params[:email])
    valid_captcha = RCC_ENABLED && !logged_in ? validate_recap(params, ActiveRecord::Errors.new(nil)) : true
    
    respond_to do |format|
      if valid_captcha
        if Mailer.deliver_contact(recipient, user, params[:subject], params[:message], request.remote_ip, request.env["HTTP_USER_AGENT"])
          flash[:notice] = "Your email was sent successfully."
        else
          flash[:error] = "We weren't able to send your email. Please try again later."
        end
      else
        flash[:error] = "Captcha failed. Please try again."
      end
      format.html { redirect_to :controller => "contact" }
    end
  end
  
  protected
  
  def check_form
    if session[:user_id].nil?
      email_reg = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i 
      valid_email = email_reg.match(params[:email])? true : false
      empty_name = params[:name].empty?
    else
      valid_email = true
      empty_name = false
    end
    
    empty_subject = params[:subject].empty?
    empty_message =  params[:message].empty?
    
    if !valid_email || empty_name || empty_subject || empty_message
      flash[:error] = "Your message could not be sent."
      respond_to do |format|
        format.html { redirect_to :controller => "contact" }
      end
    end
  end
end
