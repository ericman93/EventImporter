class RequestsController < ApplicationController
	before_action :has_user_session?, only: [:select_proposal, :remove_request, :user_requests, :requests, :single_request, :request, :requests_count]
	before_action :check_if_currnet_user, only: [:request_data, :single_request]
	before_action :set_full_user, only: [:select_proposal, :requests_count, :user_requests]

	def insert_proposels
		user_name = params[:user_name]
		requester_info = params[:request_info]
		param_proposals = params[:proposals].to_a
		event_metadata = params[:event_metadata]
		gmt_offset = params[:gmt_offset]

		user = User.where("user_name = ?",user_name).first	
		props = RequestProposal.from_json(param_proposals)

		if(user.is_auto_approval)
			if(props.size != 1)
				render text: "You can select only one proposel", status: 400
			else
				RequestHelper.auto_approve(props.first, user, requester_info, event_metadata)

				render json: true
			end
		else
			request, error = RequestHelper.save_request(props, user, requester_info, event_metadata)
			if request.nil?
				render text: error, status: 400
			else
				RequestMailer.requests_email(request, user).deliver
				render json: true
			end
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
		#RequestMailer.proposle_accept_email(proposal, @current_full_user).deliver
		@current_full_user.mail_importer.each do |importer| 
			importer.specific.send_proposal(proposal)
		end
		Request.destroy(proposal.request.id)

		render json: true
	end

	def user_requests
		@requests = @current_full_user.requests
    	render partial: 'requests'
	end

	def request_data
		request_id = params[:request_id]
		@request = Request.find(request_id)

		render partial: 'single_request'
	end

  	def requests_count
    	requests_count = 0
		if !@current_full_user.nil?
    		requests_count = @current_full_user.requests.size
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

			if(request.user.id != @current_userid)
				redirect_to controller: :users, action: :calendar, status: 302, username: @current_username
				#redirect_to action: :login, controller: :permissions, status: 302
			end
		end

		def auto_approve
		end
end