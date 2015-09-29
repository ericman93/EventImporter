
class GmailImporter < ActiveRecord::Base
	acts_as :mail_importer, :as => :importer

	@@possible_errors = 0;

	# add refresh_token and exprestion date
	# whenever try to get token , check if expired 
	# if it is so get a new one and save in db

	def get_events(start_time, end_time)
		if self.expired?
			logger.debug('expired !@#$')
			GmailHelper.refresh_token(self, logger)
		end

		return get_gmail_events(start_time,end_time)["items"].map{|item| to_event_object(item)}
	end

	def expired?
		return DateTime.now.utc >= self.expiration_date
	end

	def get_token
		if self.expired?
			GmailHelper.refresh_token(self, logger)
		end
		
		self.token
	end

	def send_proposal(proposal)
		client = get_gmail_client
		service = client.discovered_api('calendar', 'v3')

		gmail_event = {
			'summary' => proposal.request.subject,
			'location' => proposal.request.location,
			'description' => 'Created by Scheddy.me',
			'start' => {
				'dateTime' => proposal.start_time.strftime("%FT%T%:z"), 
			},
			'end' => {
				'dateTime' => proposal.end_time.strftime("%FT%T%:z"), 
			},
			'attendees' => [
			    {
			    	'email' => proposal.request.return_mail,
			    	'responseStatus' => "accepted"
		    	},
			    {
			    	'email' => user.email,
			    	'responseStatus' => "accepted"
		    	}
			]
		};

		result = client.execute(
	    	:api_method => service.events.insert,
	      	:parameters => {
      			:calendarId => 'primary',
      			:sendNotifications => true
			},
			:body_object => gmail_event,
	      	:headers => {'Content-Type' => 'application/json'}
      	)

      	RequestMailer.proposle_selected_email(proposal, user).deliver
	end

	def get_user_email
		client = get_gmail_client;
		service = client.discovered_api('plus', 'v1')

		user = client.execute(
			service.people.get,
			{'userId' => 'me'}
		);

		return user.data.emails.map{|email| email.value}.join(', ')
	end

	private
		def get_gmail_client()
			client = Google::APIClient.new
    		client.authorization.access_token = self.token

			return client
		end

		def get_gmail_events(start_time, end_time)
			client = get_gmail_client;
			service = client.discovered_api('calendar', 'v3')

			events = client.execute(
		      :api_method => service.events.list,
		      :parameters => {'calendarId' => 'primary',
		      				  'timeMin' => start_time.as_json(),
		      				  'timeMax' => end_time.as_json() },
		      :headers => {'Content-Type' => 'application/json'})

			return events.data
		end

		def to_event_object(gmail_event)
			event = Event.new
			event.id = gmail_event["iCalUID"]
			event.subject = gmail_event["summary"]
			event.location = gmail_event["location"]
			event.start_time = gmail_event["start"]["dateTime"]
			event.end_time = gmail_event["end"]["dateTime"]

			event
		end
end
