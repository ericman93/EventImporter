class User < ActiveRecord::Base
	validates :email, uniqueness: true
	
	def events
		EventUser.where("email = ?", self.email).map{|eu| eu.event}
	end
end
