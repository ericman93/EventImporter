class User < ActiveRecord::Base
	validates_format_of :email, :with => /@/ ,:message => "Invalid email address" 
	validates_format_of :user_name, :with => /[^-\s]*/ ,:message => "Invalid email address" 
	validates :first_name, :presence => { :message => "First name is required" }
	validates :last_name, :presence => { :message => "Last name is required" }
	validates :password, :presence => { :message => "Password is required" }
	validates :user_name, :presence => { :message => "User name is required" }
	validates :email, uniqueness: true
	validates :user_name, uniqueness: true

	has_many :requests
	has_many :work_hours
	has_many :mail_importer, :dependent => :destroy 

	accepts_nested_attributes_for :work_hours
	
	def events(start_time, end_time)
		#EventUser.joins(:event)
		#		 .where("event_users.email = ? and events.start_time >= ? and events.end_time <= ?", self.email, Time.at(start_time), Time.at(end_time))
		#		 .map{|eu| eu.event}

		mail_importer.inject([]){|events, importer| events += importer.specific.events(start_time, end_time)}
	end

	def all_events
		EventUser.where("email = ?", self.email).map{|eu| eu.event}
	end

	def self.authenticate(user_id, password)
		#User.any?{|u| u.id == user_id and u.password == password}
		true
	end

	def self.authenticate_by_mail(user_name, plain_password)
		#hashed_password = Digest::MD5.hexdigest(plain_password)
		hashed_password = plain_password
		User.where("upper(user_name) = ? and password = ?", user_name.upcase, hashed_password).any?
	end
end
