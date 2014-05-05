module CalendarApiHelper
	def self.handle_request(events, logger)
		events.each do |event|
			db_event = event.get_db_instnace

			if db_event.nil? 
				# no event in the db with the same event id, create new one
				event.save
			else
				# event already exists, update the event data
				db_event.update(event)
				db_event.save
			end
		end
	end
end
