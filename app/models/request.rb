class Request < ActiveRecord::Base
	validates_format_of :return_mail, :with => /@/ ,:message => "Invalid email address" 
	validates :return_name, :presence => { :message => "Return name is required" }
	validates :subject, :presence => { :message => "Subject is required" }

	belongs_to :user
	has_many :request_proposals, :dependent => :destroy 

	#subject , location , return_mail , return_name
end