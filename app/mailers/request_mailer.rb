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

  	GBody = "BEGIN:VCALENDAR
			PRODID:-//setwith.me
			VERSION:2.0
			METHOD:REQUEST
			BEGIN:VEVENT
			DTSTART:
			DTSTAMP: #{proposal.start_time.strftime('%Y%m%dT%H%m00Z')}
			DTEND:#{proposal.end_time.strftime('%Y%m%dT%H%m00Z')}
			LOCATION: #{request.location}
			UID:40000008200E00074C5B7101A82E0080000000020DC2A139243C601000000
			DESCRIPTION: #{bla}
			X-ALT-DESC;FMTTYPE=text/html:0
			SUMMARY: #{request.subject}
			ORGANIZER:MAILTO: #{}
			ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=Eric Feldman:MAILTO:ericfeldman93@gmail.com
			ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=Gadi Feldman:MAILTO:gadi_fe@hotmail.com
			END:VEVENT
			END:VCALENDAR"

  	mail(to: request.return_mail, subject: "#{user.name} as accept meeting your reuqest") do |format|
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
			  e.uid         = SecureRandom.uuid
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
