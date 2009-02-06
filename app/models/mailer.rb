class Mailer < ActionMailer::Base
  def welcome(user)
    recipients    user.email
    from          "HAAGA-HELIA Linux Club <do-not-reply@hhlinuxclub.fi>"
    subject       "Welcome to the HAAGA-HELIA Linux Club"
    sent_on       Time.now
    content_type  "text/plain"
    body          :user => user
  end
end
