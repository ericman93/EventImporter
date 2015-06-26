module ApplicationHelper
	def current_page(path)
		"current" if current_page?(path)
	end
end
