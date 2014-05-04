class CalendarApiController < ApplicationController
	protect_from_forgery with: :null_session

	def insert
		user_id = params[:userId]
		hashed_password = params[:hashedPassword]

		if !User.authenticate(user_id, hashed_password)
			render :text => "Faild to authenticate", :status => 302, :content_type => 'text/html'
		else
			events = Event.from_json params[:events] 
			events.each{|e| CalendarApiHelper.handle_request(events, logger)}

			logger.debug "thos are the atteings #{events[1].event_users.size}"
			render json: events #:nothing => true, :status => 200, :content_type => 'text/html'
		end
	end
end