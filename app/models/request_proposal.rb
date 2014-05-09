class RequestProposal < ActiveRecord::Base
	belongs_to :request

	def self.from_json(propsels)
		propsels.map do |p|
			p = p[1]
			start_time = DateTime.strptime(p[:start_ticks],'%Q')
			end_time = DateTime.strptime(p[:end_ticks],'%Q')
			
			r = RequestProposal.new
			r.start_time = start_time
			r.end_time = end_time

			r
		end
	end
end