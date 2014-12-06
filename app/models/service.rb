class Service < ActiveRecord::Base
	validates :name, :presence => { :message => "Service name is required" }
	validates :time_in_minutes, :presence => { :message => "Service time is required" }
	validates_format_of :time_in_minutes, :with => /\d+/ ,:message => "Service time must be a number" 

	belongs_to :user
end
