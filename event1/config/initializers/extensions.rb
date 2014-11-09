class ActiveSupport::TimeWithZone
	def to_ics_time
		self.strftime('%Y%m%dT%H%M%SZ')
	end
end