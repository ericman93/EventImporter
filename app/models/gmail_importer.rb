class GmailImporter < ActiveRecord::Base
	acts_as :mail_importer, :as => :importer

	@@possible_errors = 0;

	# add refresh_token and exprestion date
	# whenever try to get token , check if expired 
	# if it is so get a new one and save in db

	def events(start_time, end_time)
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

	private
		def get_gmail_events(start_time, end_time)
			client = Google::APIClient.new
    		client.authorization.access_token = self.token
			service = client.discovered_api('calendar', 'v3')

			events = client.execute(
		      :api_method => service.events.list,
		      :parameters => {'calendarId' => 'primary',
		      				  'timeMin' => Time.at(start_time).as_json(),
		      				   'timeMax' => Time.at(end_time).as_json() },
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
