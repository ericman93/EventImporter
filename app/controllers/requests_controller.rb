class RequestsController < ApplicationController
	before_action :has_user_session?, only: [:select_proposal, :remove_request, :user_requests, :requests, :single_request, :request, :requests_count]
	before_action :check_if_currnet_user, only: [:request_data, :single_request]
	before_action :set_full_user, only: [:select_proposal, :requests_count, :user_requests]

	def insert_proposels
		user_name = params[:user_name]
		requester_info = params[:request_info]
		param_proposals = params[:proposals].to_a
		event_metadata = params[:event_metadata]

		is_valid, message = validate_request_info?(requester_info, event_metadata);
		if(!is_valid)
			render text: message, status: 400
			return;
		end

		user = User.where("user_name = ?",user_name).first	
		props = RequestProposal.from_json(param_proposals)

		if(user.is_auto_approval)
			auto_approve(props, user, requester_info, event_metadata)
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

		def auto_approve(props, user, requester_info, event_metadata)
			if(props.size != 1)
				render text: "You can select only one proposel", status: 400
			else
				propsal = props.first
				event_collision = user.mail_importer.inject([]){|events, importer| events += importer.specific.event_collision(propsal.start_time, propsal.end_time)}
				if(event_collision.any?)
					render text: "#{user.first_name} #{user.last_name} is occupied at this time", status: 400
				else
					RequestHelper.auto_approve(propsal, user, requester_info, event_metadata)

					render json: event_collision.size
				end
			end
		end

		def validate_request_info?(requester_info, event_metadata)
			if requester_info.nil?
				return false, "Request info cannot be empty";
			end
			if event_metadata.nil?
				return false, "Your info cannot be empty";
			end

			if(event_metadata['subject'].nil?)
				return false, "Meeting subject field is required";
			end
			if(event_metadata['location'].nil?)
				return false, "Meeting location field is required";
			end
			if(requester_info['mail'].nil?)
				return false, "Your mail is required";
			end
			if(requester_info['name'].nil?)
				return false, "Your name is required";
			end

			return true
		end
end