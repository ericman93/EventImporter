class Event < ActiveRecord::Base
	validates :start_time, :presence => { :message => "Event start time name is required" }
	validates :end_time, :presence => { :message => "Event end time name is required" }

	attr_accessor :user

	def exists?
		Event.exists?(:event_id => self.event_id)
	end

	def get_db_instnace
		if self.is_reccurnce
			# all reccurence events has the same id
			# so i need to check that this isn't a new instance of the event.
			# otherwize only the newest instance will save
			Event.where("event_id = ? and start_time = ? and end_time = ?" ,
						self.event_id, self.start_time, self.end_time)
			     .first
		else
			Event.where(:event_id => self.event_id).first
		end
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
			'id' => self.id,
			'start' => self.start_time,
			'end' => self.end_time,
			'title' => should_remove_private_data ? "Busy" : self.subject, 
			'location' => should_remove_private_data ? "" : self.location,
			'allDay' => false,
			'className' => "#{user.user_name} #{'event-pass' if DateTime.now > self.end_time} #{should_remove_private_data ? 'busy_event' : 'user_event'}",
		}
	end

	def self.from_json(events)
		#events = JSON.parse events

		events.map do |hash_event|
			event = Event.new

			hash_event.each do |prop_name, prop_value|
				#TODO: if prop_value is hash , create new instance of prop_name and user the from_json on the prop_value ( and not change the name of the prop)
				#if prop_name == 'EventUsers'
				#	prop_value = prop_value.map{|v| EventUser.new(:email => v["Email"], 
				#												  :is_approved => v["Approved"])
				#							}
				if prop_name.end_with?('time')
					unix = prop_value.to_s.match /\d+/
					prop_value = DateTime.strptime(unix[0],'%Q').utc # in the case that i resive milisconds from 1970
				end

				event.send("#{prop_name.downcase}=", prop_value)
			end

			event
		end
	end
end
