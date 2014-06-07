class CalendarApiController < ApplicationController
	protect_from_forgery with: :null_session
	before_action :has_user_session?, only: [:select_proposal]

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
		user_mail = params[:email]
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

	def select_proposal
		proposal_id = params[:proposal_id]

		proposal = RequestProposal.find(proposal_id)
		RequestMailer.proposle_accept_email(proposal, @current_user).deliver
		Request.destroy(proposal.request.id)

		render json: true
	end

	private
    	def has_user_session?
      		if session[:current_user].nil?
        		redirect_to action: :login, controller: :users, status: 302
      		end
  		end
end