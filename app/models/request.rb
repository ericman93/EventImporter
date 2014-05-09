class Request < ActiveRecord::Base
	belongs_to :user
	has_many :request_proposals
end