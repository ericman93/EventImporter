class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception	
  before_filter :set_current_user
  before_filter :init_regiester_user

	def set_current_user
		@current_user = session[:current_user]
	end

	def has_user_session?
		if session[:current_user].nil?
			redirect_to :controller => 'about', :action => 'home', show_login: true
		end
	end

	def init_regiester_user
		if(session[:current_user].nil?)
			@user = User.new
		end
	end
end
