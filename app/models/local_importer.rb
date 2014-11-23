class LocalImporter < ActiveRecord::Base
	acts_as :mail_importer, :as => :importer

	def events(start_time, end_time)
		EventUser.joins(:event)
		 		 .where("event_users.email = ? and events.start_time >= ? and events.end_time <= ?", self.user.email, Time.at(start_time), Time.at(end_time))
		 		 .map{|eu| eu.event}
	end
end
