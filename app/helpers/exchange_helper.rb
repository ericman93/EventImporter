require 'viewpoint'
include Viewpoint::EWS

module ExchangeHelper
	def self.connect_to_server(server, user, password)
		return Viewpoint::EWSClient.new "https://#{server}/ews/Exchange.asmx", user, password
	end

	def self.test_connection(server, user, password)
		client = ExchangeHelper.connect_to_server(server, user, password)

		begin  
	    	client.search_contacts(user).first.email
	    	return true
		rescue
			return false
		end
	end
end
