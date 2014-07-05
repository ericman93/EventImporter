class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception	
  before_filter :set_current_user

	def set_current_user
		@current_user = session[:current_user]
	end

  	def has_user_session?
		if session[:current_user].nil?
			redirect_to action: :login, controller: :permissions, status: 302
		end
	end
end
