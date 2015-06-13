class Group < ActiveRecord::Base  
	validates :name, uniqueness: true

  	groupify :group, members: [:users, :assignments], default_members: :users

	def admin?(user)
  		user.in_group?(self, as: 'manager')
  	end

  	def events(start_time, end_time)
		users.inject([]) do |events, user|
			events += user.mail_importer.inject([]) do |user_events, importer| 
				user_events += importer.specific.events(start_time, end_time)
			end
		end
	end

	def user_name
		name
	end
	def is_auto_approval
		false
	end
	def services
		[]
	end
	def first_name
		name
	end
	def last_name
	end
	def picture_path
		nil
	end
	def desc
		"stop it"
	end
end