class Event < ActiveRecord::Base
	validates :start_time, :presence => { :message => "Event start time name is required" }
	validates :end_time, :presence => { :message => "Event end time name is required" }

	has_many :event_users

	def exists?
		Event.exists?(:event_id => self.event_id)
	end

	def get_db_instnace
		Event.where(:event_id => self.event_id).first
	end

	def update(other)
		self.subject = other.subject
		self.location = other.location
		self.start_time = other.start_time
		self.end_time = other.end_time
	end

	# return json representation of the events as the fullCalendar know to handle
	def to_fullcalendar_json(should_remove_private_data)
		{
			'start' => self.start_time.to_i,
			'end' => self.end_time.to_i,
			'title' => should_remove_private_data ? "Busy" : self.subject, 
			'color' => should_remove_private_data ? 'red' : 'blue',
			'location' => should_remove_private_data ? "" : self.location,
			'allDay' => false
		}
	end

	def self.from_json(events)
		events = JSON.parse events

		events.map do |hash_event|
			event = Event.new

			hash_event.each do |prop_name, prop_value|
				#TODO: if prop_value is hash , create new instance of prop_name and user the from_json on the prop_value ( and not change the name of the prop)
				if prop_name == 'EventUsers'
					prop_value = prop_value.map{|v| EventUser.new(:email => v["Email"], 
																  :is_approved => v["Approved"])
											}
				elsif prop_name.end_with?('Time')
					unix = prop_value.match /\d+/
					prop_value = DateTime.strptime(unix[0],'%Q').utc # in the case that i resive milisconds from 1970
				end

				event.send("#{to_underscore(prop_name)}=", prop_value)
			end
			logger.debug "event time #{event.start_time}"

			event
		end
	end

	private
		def self.to_underscore(str)
			str_dup = str.dup
			str_dup.gsub!(/(.)([A-Z])/,'\1_\2')
	   	 	str_dup.downcase!
		end
end
