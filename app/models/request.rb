class Request < ActiveRecord::Base
	belongs_to :user
	has_many :request_proposals

	#subject , location , return_mail , return_name
end