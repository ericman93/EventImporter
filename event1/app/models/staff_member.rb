class StaffMember
	attr_accessor :name, :desc, :tags, :pic_name, :location, :social_media

	def intialize
		tags = []
		social_media = []
	end

	def add_social_network(name, url)
		social_media << {name: name, url: url}
	end
end