Rails.application.config.middleware.use OmniAuth::Builder do
  	provider :google_oauth2, Rails.configuration.google_api[:client_id], Rails.configuration.google_api[:client_secret], {
		    access_type: 'offline',
		    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
		    redirect_uri: Rails.configuration.google_api[:redirect_uri]
		    #:client_options => {:ssl => {:verify => false}}
		  }
end