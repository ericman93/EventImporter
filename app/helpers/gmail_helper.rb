require 'net/http'
require 'uri'

module GmailHelper
	def self.refresh_token(gmail_importer, logger)
		new_token, expires_in_seconds = self.get_token_with_experation(gmail_importer.refresh_token, logger)
		gmail_importer.token = new_token
		gmail_importer.expiration_date = DateTime.now.utc + expires_in_seconds.seconds

		gmail_importer.save
	end

	private
		def self.get_token_with_experation(refresh_token, logger)
			data = "grant_type=refresh_token&refresh_token=#{refresh_token}&client_id=#{Rails.configuration.google_api[:client_id]}&client_secret=#{Rails.configuration.google_api[:client_secret]}"
			url = URI.parse('https://accounts.google.com/o/oauth2/token')
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true

			request = Net::HTTP::Post.new(url.path, {'Content-Type' =>'application/x-www-form-urlencoded'})
			request.body = data

			logger.debug("123456 #{request.body}")
			response = http.request(request)
			json_result = JSON.parse(response.body)
			return json_result["access_token"], json_result["expires_in"].to_i
		end
end
