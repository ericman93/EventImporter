class User < ActiveRecord::Base
	has_many :requests
	validates :email, uniqueness: true
	
	def events
		EventUser.where("email = ?", self.email).map{|eu| eu.event}
	end

	def self.authenticate(user_id, password)
		#User.any?{|u| u.id == user_id and u.password == password}
		true
	end

	def self.authenticate_by_mail(email, plain_password)
		#hashed_password = Digest::MD5.hexdigest(plain_password)
		hashed_password = plain_password

    	puts "aaaaaaaaaaaaaaaaaa--------------- #{email} - #{plain_password}"
		User.where("upper(email) = ? and password = ?", email.upcase, hashed_password).any?
	end
end
