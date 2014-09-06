class User < ActiveRecord::Base
	validates_format_of :email, :with => /@/ ,:message => "Invalid email address" 
	validates :name, :presence => { :message => "Name is required" }
	validates :password, :presence => { :message => "Password is required" }

	has_many :requests
	has_many :work_hours
	validates :email, uniqueness: true

	accepts_nested_attributes_for :work_hours
	
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
		User.where("upper(email) = ? and password = ?", email.upcase, hashed_password).any?
	end
end
