class RequestMailer < ActionMailer::Base
  default from: "ericfeldman93@gmail.com"

  def welcome_email()
    mail(to: "ericfeldman93@gmail.com", subject: 'Welcome to My Awesome Site')
  end

  def requests_email(request, user_mail)
  	@request = request
  	mail(to: user_mail, subject: "You got a meeting request from #{request.return_name}")
  end
end
