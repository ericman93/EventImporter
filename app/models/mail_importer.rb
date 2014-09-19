class MailImporter < ActiveRecord::Base
	acts_as_superclass :as => :importer
	belongs_to :user

	def events(start_time, end_time)
	end
end
