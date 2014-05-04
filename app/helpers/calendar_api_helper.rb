module CalendarApiHelper
	def self.handle_request(events, logger)
		events.select{|e| !e.exists?}.tap{|e| logger.debug "big bam bam #{e.size}"}.each{|e| e.save}
	end
end
