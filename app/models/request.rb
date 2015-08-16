class Request < ActiveRecord::Base
	belongs_to :user
	has_many :request_proposals, :dependent => :destroy 

	validates_format_of :return_mail, :with => /.+@.+/ ,:message => "Invalid email address" 
	validates :return_name, :presence => { :message => "Return name is required" }
	validates :subject, :presence => { :message => "Subject is required" }
	#subject , location , return_mail , return_name
end