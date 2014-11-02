class PermissionsController < ApplicationController
  	def login
	    if !@current_user.nil?
	       redirect_to @current_user
	    else
	      render :login
	    end
 	end

  	def logout
	    session[:current_user] = nil
	    redirect_to action: :login, status: 302
  	end

  	def authenticate
	    plaintext_password = params[:password]
	    user_name = params[:username]

	    if(!User.authenticate_by_mail(user_name, plaintext_password))
	        redirect_to action: :login, status: 302
	    else
	        session[:current_user] = User.find_by user_name: user_name
	        redirect_to controller: :users, action: :calendar, status: 302, username: user_name
	    end
  	end
end