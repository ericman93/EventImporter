module CalendarApiHelper
	def self.handle_request(events, logger)
		events.each do |event|
			db_event = event.get_db_instnace
			logger.debug "event name : #{event.subject}"

			if db_event.nil?
				event.save
			else
				db_event.update(event)
				logger.debug "to update new suject : #{db_event.subject}"
				db_event.save
			end
		end
	end
end
