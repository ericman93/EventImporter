module CalendarApiHelper
	def self.handle_request(events, logger)
		events.each do |event|
			logger.debug("start inserting meeting - '#{event.subject}'")
			db_event = event.get_db_instnace

			if db_event.nil? 
				# no event in the db with the same event id, create new one
				if !event.save
					logger.error("could not insert #{event.subject} : #{event.errors.first[1]}")
				end
			else
				# event already exists, update the event data
				if !db_event.update(event)
					logger.error("could not update #{db_event.subject} : #{db_event.errors.first[1]}")
				end
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

		busy
	end

	def self.handle_proposle(proposels, user, requester, event_metadata)
		request = Request.new()
		request.subject = event_metadata['subject'] 
		request.location = event_metadata['location'] 
		request.return_mail = requester['mail'] 
		request.return_name = requester['name']

		request.request_proposals = proposels
		user.requests << request

		if user.save
			return request, nil
		else
			return nil, request.errors.first[1]
		end
	end

	private
		def self.is_start_between(first, second)
			first.start_time <= second.start_time and first.end_time >= second.start_time
		end
end
