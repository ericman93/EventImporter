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

	def send_user_event_options
		user_mail = "ericfeldman93@gmail.com" #params[:email]
		requester_info = params[:request_info]
		param_proposals = params[:proposals].to_a
		event_metadata = params[:event_metadata]
		gmt_offset = params[:gmt_offset]

		user = User.where("email = ?",user_mail).first
		props = RequestProposal.from_json(param_proposals)

		request = CalendarApiHelper.handle_proposle(props, user, requester_info, event_metadata)
		RequestMailer.requests_email(request, user_mail).deliver

		render json: true
	end
end