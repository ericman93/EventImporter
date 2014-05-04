class Event < ActiveRecord::Base
	has_many :event_users

	def exists?
		Event.exists?(:event_id => self.event_id)
	end

	def self.from_json(events)
		events = JSON.parse events

		events.map do |hash_event|
			event = Event.new

			hash_event.each do |prop_name, prop_value|
				if prop_name == 'EventUsers'
					prop_value = prop_value.map{|v| EventUser.new(:email => v["Email"], 
																  :is_approved => v["Approved"])
											}
				end

				logger.debug "tiras ham2 #{prop_value[0].email}" if prop_name == 'EventUsers'
				event.send("#{to_underscore(prop_name)}=",prop_value)
			end

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
