class ExchangeImporter < ActiveRecord::Base
	acts_as :mail_importer, :as => :importer

	@@exepteable_types = ['Busy', 'OOF']
	@@possible_errors = 0;

	def get_events(start_time, end_time)
		client = ExchangeHelper.connect_to_server(self.server, self.user_name, self.password)
		gmt = 0; # I want the events as UTC 
		time_zone = {:bias => (gmt*60).to_s}

		events = get_events_from_folder(client, start_time, end_time , time_zone).compact

		return events
	end

	def expired?
		return DateTime.now.utc >= self.expiration_date
	end

	private
		def get_element_value(element, key_name)
			element.select{|hash| hash.has_key?(key_name)}.first[key_name][:text]
		end

		def get_events_from_availvailty(exchnge_client, start_time, end_time, time_zone)
			email = make_call_to_server(@@possible_errors, nil) do
				exchnge_client.search_contacts(user_name).first.email
			end
			
			busy_times = make_call_to_server(@@possible_errors, []) do 
				user_free_busy = exchnge_client.get_user_availability([email],
					  start_time: start_time,
					  end_time:   end_time,
					  time_zone: time_zone,
					  requested_view: :free_busy)
				busy_times = user_free_busy.calendar_event_array
			end
			
			return busy_times.map do |event|
				element = event[:calendar_event][:elems]
				if @@exepteable_types.include?(get_element_value(element, :busy_type))
					start_string = get_element_value(element, :start_time)
					end_string = get_element_value(element, :end_time)

					to_event_object(start_string, end_string)
				end
			end
		end

		def get_events_from_folder(exchnge_client, start_time, end_time, time_zone)
			email = make_call_to_server(@@possible_errors, nil) do
				exchnge_client.search_contacts(user_name).first.email
			end
			
			calendar_view_args = {
			  max_entries_returned: 500,
			  start_date: start_time.to_time.iso8601,
			  end_date: end_time.to_time.iso8601
			}

			items = make_call_to_server(@@possible_errors, []) do 
				calendar_folder = exchnge_client.get_folder_by_name 'Calendar'
				shallow_items = calendar_folder.items(item_shape: { base_shape: 'IdOnly' }, calendar_view: calendar_view_args)
				item_ids = shallow_items.map(&:id)

				items = if item_ids.any?
				  # Must do a second GetItems call as FindItems is incapable of returning
				  # item:Body. Some details here: http://msdn.microsoft.com/en-us/library/office/gg236897(v=exchg.140).aspx
				  item_shape_args = {
				    base_shape: 'AllProperties',
				    body_type: 'Text',
				  }

				  calendar_folder.get_items(item_ids, item_shape: item_shape_args)
				else
				  []
				end
			end

			return items.map do |item|
					event = Event.new
					event.id = -1
					event.subject = item.subject
					event.start_time = item.start
					event.end_time = item.end
					event.location = item.location
#
					event
				end
		end

		def to_event_object(start_string, end_string)
			event = Event.new
			event.id = -1
			event.subject = "Busy"
			event.start_time = DateTime.parse(start_string).utc
			event.end_time = DateTime.parse(end_string).utc

			event
		end
end
