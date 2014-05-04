class User < ActiveRecord::Base
	validates :email, uniqueness: true
	
	def events
		EventUser.where("email = ?", self.email).map{|eu| eu.event}
	end

	def self.authenticate(user_id, password)
		#User.any?{|u| u.id == user_id and u.password == password}
		true
	end
end
