class RequestsController < ApplicationController
	before_action :has_user_session?, only: [:select_proposal, :remove_request, :user_requests, :requests, :single_request, :request, :requests_count]
	before_action :check_if_currnet_user, only: [:request_data, :single_request]

	def insert_proposels
		user_name = params[:user_name]
		requester_info = params[:request_info]
		param_proposals = params[:proposals].to_a
		event_metadata = params[:event_metadata]
		gmt_offset = params[:gmt_offset]

		user = User.where("user_name = ?",user_name).first
		props = RequestProposal.from_json(param_proposals)

		request, error = CalendarApiHelper.handle_proposle(props, user, requester_info, event_metadata)
		if request.nil?
			render text: error, status: 400
		else
			RequestMailer.requests_email(request, user).deliver
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
		user = User.find(@current_user.id)
		#RequestMailer.proposle_accept_email(proposal, @current_user).deliver
		user.mail_importer.each do |importer| 
			importer.specific.send_proposal(proposal)
		end
		Request.destroy(proposal.request.id)

		render json: true
	end

	def user_requests
		@requests = User.find(@current_user.id).requests
    	render partial: 'requests'
	end

	def request_data
		request_id = params[:request_id]
		@request = Request.find(request_id)

		render partial: 'single_request'
	end

  	def requests_count
    	requests_count = 0
		if !session[:current_user].nil?
    		requests_count = User.find(session[:current_user].id).requests.size
    	end

    	render json: requests_count
  	end

  	def single_request
  		# will render the single_request.html.erb view
  		@request_id = params[:request_id]
  	end

	def requests
		# will render the request.html.erb view
	end

	private 
		def check_if_currnet_user
			request_id = params[:request_id]
			request = Request.find(request_id)

			if(request.user.id != @current_user.id)
				redirect_to controller: :users, action: :calendar, status: 302, username: @current_user.user_name
				#redirect_to action: :login, controller: :permissions, status: 302
			end
		end
end