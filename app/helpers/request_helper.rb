module RequestHelper
	def self.auto_approve(proposel, user, requester, event_metadata)
		request = create_reuqest(requester, event_metadata)
		proposel.request = request

		user.mail_importer.each do |importer| 
			importer.specific.send_proposal(proposel)
		end
	end

	def self.save_request(proposels, user, requester, event_metadata)
		request = create_reuqest(requester, event_metadata)
		request.request_proposals = proposels
		user.requests << request

		if user.save
			return request, nil
		else
			return nil, request.errors.first[1]
		end
	end

	private
		def self.create_reuqest(requester, event_metadata)
			request = Request.new()
			request.subject = event_metadata['subject'] 
			request.location = event_metadata['location'] 
			request.return_mail = requester['mail'] 
			request.return_name = requester['name']

			return request
		end
end
