class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception	
  before_filter :set_current_username
  before_filter :init_regiester_user

	def set_current_username
		@current_username = session[:current_username]
		@current_userid = session[:current_userid]
	end

	def set_full_user
		@current_full_user = User.find(@current_userid)
	end

	def has_user_session?
		if session[:current_username].nil?
			redirect_to :controller => 'about', :action => 'home', show_login: true
		end
	end

	def init_regiester_user
		if(session[:current_username].nil?)
			@user = User.new
		end
	end
end
