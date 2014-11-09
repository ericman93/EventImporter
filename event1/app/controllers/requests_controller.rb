class RequestsController < ApplicationController
	before_action :has_user_session?, only: [:select_proposal, :remove_request, :user_requests, :requests, :requests_count]

	def insert_proposels
		user_mail = params[:email]
		requester_info = params[:request_info]
		param_proposals = params[:proposals].to_a
		event_metadata = params[:event_metadata]
		gmt_offset = params[:gmt_offset]

		user = User.where("email = ?",user_mail).first
		props = RequestProposal.from_json(param_proposals)

		request, error = CalendarApiHelper.handle_proposle(props, user, requester_info, event_metadata)
		if request.nil?
			render text: error, status: 400
		else
			RequestMailer.requests_email(request, user_mail).deliver
			render json: true
		end
	end

	def remove_request
		request_id = params[:request_id]
		Request.destroy(request_id)

		render json: true
	end

	def select_proposal
		proposal_id = params[:proposal_id]

		proposal = RequestProposal.find(proposal_id)
		RequestMailer.proposle_accept_email(proposal, @current_user).deliver
		Request.destroy(proposal.request.id)

		render json: true
	end

	def user_requests
		@requests = User.find(@current_user.id).requests
    	render partial: 'requests'
	end

  	def requests_count
    	requests_count = 0
		if !session[:current_user].nil?
    		requests_count = User.find(session[:current_user].id).requests.size
    	end

    	render json: requests_count
  	end

	def requests
	  	# will render the request.html.erb view
	end
end