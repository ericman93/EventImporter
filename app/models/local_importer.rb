class LocalImporter < ActiveRecord::Base
	acts_as :mail_importer, :as => :importer

	def events(start_time, end_time)
		EventUser.joins(:event)
		 		 .where("event_users.email = ? and events.start_time >= ? and events.end_time <= ?", self.user.email, Time.at(start_time), Time.at(end_time))
		 		 .map{|eu| eu.event}
	end

	def send_proposal(proposal)
		super(proposal)

		event = Event.new
		event.start_time = proposal.start_time
		event.end_time = proposal.start_time
		event.subject = proposal.request.subject
		event.location = proposal.request.location

		event_user = EventUser.new
		event_user.email = user.email
		event.event_users << event_user

		event.save
	end
end
