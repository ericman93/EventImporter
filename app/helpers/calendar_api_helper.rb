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

	def self.combine_events(events,logger)
		busy = []
		i = 0

		until i == events.size
			temp = events[i]

			while(i+1 < events.size and is_start_between(temp, events[i+1]))
				logger.debug "abcdefg #{temp.subject}"
				temp.start_time = temp.start_time
				temp.end_time = (temp.end_time > events[i + 1].end_time ? temp.end_time : events[i + 1].end_time)

				i += 1
			end

			i += 1
			busy << temp
		end

		# remove private data
		busy.each do |b|
			b.subject = ""
			b.location = ""
		end

		busy
	end

	private
		def self.is_start_between(first, second)
			first.start_time <= second.start_time and first.end_time >= second.start_time
		end
end
