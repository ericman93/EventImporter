Calendar::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }

  config.action_mailer.smtp_settings = {
    :address              => "vhummuscom.ipage.com", 
    :port                 => "587",
    :domain               => '127.0.0.1',
    :user_name            => 'gadi@vhummus.com',
    :password             => 'Aueujo12!',
    :authentication       => 'plain',
    :enable_starttls_auto => false    
  }

  config.action_mailer.default_options = {
    :from                 => "mailer@scheddy.me"
  }

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.

  config.assets.debug = false
  config.assets.logger = false

  config.google_api = {
    :client_id => '793188286109-mkru8uan52gaen4curjj0m7r8emaj8on.apps.googleusercontent.com',
    :client_secret => 'B9HTYcNr9onoGvgsjfhuxVKA',
    :redirect_uri => 'http://localhost:3000/auth/google_oauth2/callback',
  }
end
