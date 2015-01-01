class PermissionsController < ApplicationController
  	#def login
	#    if !@current_userid.nil?
	#       redirect_to @current_userid
	#    else
	#      render :login
	#    end
 	#end

  	def logout
  		@user = User.new
	    session[:current_username] = nil
	    
	    redirect_to :root, status: 302
  	end

  	def authenticate
	    plaintext_password = params[:password]
	    user_name = params[:username]

	    if(!User.authenticate_by_mail(user_name, plaintext_password))
	        redirect_to action: :login, status: 302
	    else
	        user = User.find_by user_name: user_name
	        session[:current_username] = user.user_name
	        session[:current_userid] = user.id 
	        redirect_to controller: :users, action: :calendar, status: 302, username: user_name
	    end
  	end

  	def authorize
  		plaintext_password = params[:password]
	    user_name = params[:username]

	    authorize = User.authenticate_by_mail(user_name, plaintext_password)
	    if(authorize)
	    	user = User.find_by user_name: user_name
	    	session[:current_username] = user.user_name
	        session[:current_userid] = user.id 
	    end

	    render json: authorize
  	end
end