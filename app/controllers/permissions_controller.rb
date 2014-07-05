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
	    email = params[:email]

	    if(!User.authenticate_by_mail(email, plaintext_password))
	        redirect_to action: :login, status: 302
	    else
	        session[:current_user] = User.find_by email: email
	        redirect_to controller: :users, action: :calendar, status: 302, email: email
	    end
  	end
end