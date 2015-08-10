require 'icalendar'

class RequestMailer < ActionMailer::Base
  #default from: "ericfeldman93@gmail.com"

  def welcome_email()
    mail(to: "ericfeldman93@gmail.com", subject: 'Welcome to My Awesome Site')
  end

  def requests_email(request, user)
  	@request = request
    @user = user  
      
  	mail(to: user.email, subject: "You got a meeting request from #{request.return_name}")
  end

  def proposle_accept_email(proposal, user)
  	request = proposal.request

  	ics_body = "BEGIN:VCALENDAR
PRODID:-//setwith.me
VERSION:2.0
METHOD:REQUEST
BEGIN:VEVENT
DTSTART:#{proposal.start_time.to_ics_time}
DTSTAMP:#{proposal.start_time.to_ics_time}
DTEND:#{proposal.end_time.to_ics_time}
LOCATION: #{request.location}
UID:#{SecureRandom.uuid}
DESCRIPTION:Change !
X-ALT-DESC;FMTTYPE=text/html:0
SUMMARY:#{request.subject}
ORGANIZER:#{request.return_mail}
ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=#{user.first_name}:MAILTO:#{user.email}
ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=#{request.return_name}:MAILTO:#{request.return_mail}
END:VEVENT
END:VCALENDAR"

  	#mail(:from => request.return_mail, :reply_to => request.return_mail,
    mail(:from => user.email, :reply_to => user.email,
  		 :to => [request.return_mail, user.email], 
		 :subject => "Calendar #{Time.now.to_i}", :content_type => "text/calendar") do |format|
  			format.ics{
  				render :text => ics_body, :layout => false
  			}
  	end	
  end
end
