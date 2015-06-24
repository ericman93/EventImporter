class RegistrationKey < ActiveRecord::Base
	after_initialize :generate_key, :if => :new_record?
	belongs_to :user

	def generate_key
		self.key = (0...8).map { ('A'..'Z').to_a[rand(26)] }.join
	end
end
