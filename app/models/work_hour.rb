class WorkHour < ActiveRecord::Base
	belongs_to :user
	#start_at - seconds from 0am
	#end_at - seconds from 0am
	#day - the name of the day
	def self.buildWorkDay(day_name)
		day = WorkHour.new
		day.day = day_name
		day.start_at = 0
		day.end_at = 0
		day
	end

	def short_day_name
		day[0..2].downcase
	end

	def to_am_show(time_name)
		seconds = self.send("#{time_name}_at")
		
		hour = seconds / 3600.0
		min = (hour % 1) * 60
		"#{hour.floor}:#{min.to_i}"
	end
end
