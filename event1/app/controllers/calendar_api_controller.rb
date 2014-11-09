class CalendarApiController < ApplicationController
	protect_from_forgery with: :null_session
	
	def insert
		user_id = params[:userId]
		hashed_password = params[:hashedPassword]

		if !User.authenticate(user_id, hashed_password)
			render :text => "Faild to authenticate", :status => 302, :content_type => 'text/html'
		else
			# maybe insted of add the user that attached to the event , add only the user with the user id 
			events = Event.from_json params[:events] 
			CalendarApiHelper.handle_request(events, logger)

			#render :nothing => true, :status => 200, :content_type => 'text/html' -> jquery parse this is an error because it cannot prarse none as json
			render json: true
		end
	end
end