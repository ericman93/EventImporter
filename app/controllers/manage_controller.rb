class ManageController < ApplicationController
	before_filter :set_full_user
	before_filter :admin?

	def index

	end

	def user_info
		
	end

	private
		def admin?
			if(!@current_full_user.is_admin)
				redirect_to :controller => 'about', :action => 'home', show_login: true	
			end
		end	
end