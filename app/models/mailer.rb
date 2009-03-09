class Mailer < ActionMailer::Base
  def welcome(user)
    recipients    user.email
    from          "HAAGA-HELIA Linux Club <do-not-reply@hhlinuxclub.fi>"
    subject       "Welcome to the HAAGA-HELIA Linux Club"
    
    part  :content_type => "text/html",
          :body => render_message("welcome.html.erb",
          :user => user)
    
    part  "text/plain" do |p|
      p.body = render_message("welcome.plain.erb",
      :user => user)
      p.transfer_encoding = "base64"
    end
  end
  
  def contact(recipient, user, contact_subject, message, ip_address, user_agent)
    recipients    recipient
    from          "HHLC Contact Form <do-not-reply@hhlinuxclub.fi>"
    reply_to      user.email
    subject       contact_subject
    sent_on       Time.now
    content_type  "text/plain"
    body          :message => message, :ip_address => ip_address, :user_agent => user_agent, :user => user
  end
  
  def credentials(user, host)
    recipients    user.email
    from          "HAAGA-HELIA Linux Club <do-not-reply@hhlinuxclub.fi>"
    subject       "Credentials request for the HAAGA-HELIA Linux Club"
    sent_on       Time.now
    content_type  "text/plain"
    body          :user => user, :host => host
  end
end
