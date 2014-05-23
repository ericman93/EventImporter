require 'icalendar'

class RequestMailer < ActionMailer::Base
  default from: "ericfeldman93@gmail.com"

  def welcome_email()
    mail(to: "ericfeldman93@gmail.com", subject: 'Welcome to My Awesome Site')
  end

  def requests_email(request, user_mail)
  	@request = request
  	mail(to: user_mail, subject: "You got a meeting request from #{request.return_name}")
  end

  def proposle_accept_email(proposal, user)
  	request = proposal.request

  	mail(to: request.return_mail, subject: "#{user.name} as accept your reuqest") do |format|
  		format.ics {
  		   cal = Icalendar::Calendar.new
	       cal.event do |e|
			  e.dtstart     = Icalendar::Values::DateTime.new proposal.start_time, 'tzid' => "UTC"
			  e.dtend       = Icalendar::Values::DateTime.new proposal.end_time, 'tzid' => "UTC"
			  e.summary     = request.subject
			  e.location    = request.location
			  e.append_attendee request.return_mail
			  e.append_attendee user.email
			  e.description = "Have a long lunch meeting and decide nothing..."
			  e.ip_class    = "PRIVATE"
		   end
		   cal.timezone do |t|
		   	t.tzid = "UTC"
		   end
	       
	       cal.publish
	       render :text => cal.to_ical, :layout => false
      }
  	end
  end
end
