Calendar::Application.routes.draw do
  root :to => 'about#home'

  # Auth
  post '/authenticate', to: 'permissions#authenticate'
  post '/authorize', to: 'permissions#authorize'
  #get '/login', to: 'permissions#login', :as => :login
  get '/logout', to: 'permissions#logout', :as => :logout

  # Settings
  get '/settings/work_hours', to:'settings#work_hours', :as => :settings_hours
  get '/settings/web_mails', to:'settings#web_mails', :as => :settings_mails
  get '/settings/services', to: 'settings#services', :as => :settings_services
  patch '/settings/work_hours', to:'settings#save_work_hours'
  patch '/settings/services', to:'settings#save_services'
  get '/settings/logout', to:'settings#logout_gmail'

  post '/exchange/test', to: 'exchange#test' 
  post '/exchange', to:'exchange#create'
  patch '/exchange', to:'exchange#edit'
  delete '/exchange', to:'exchange#remove'
  delete '/exchange/:id', to: 'exchange#remove', :as => :exchange_importer

  post '/local', to:'local_events#create'
  delete '/local/:id', to: 'local_events#remove', :as => :local_events_importer
  put '/local', to:'local_events#add_event'

  # Events
  get '/events/:username', to: 'events#user_events'
  get '/events/:id', to: 'events#show', :constraints => { :id => /\d+/ }
  #get '/requests/:request_id', to: 'events#user_requests_events'
  
  # API
  post '/calendarapi/insert', to: 'calendar_api#insert'
  
  # Request
  get  '/requests', to:'requests#requests', :as => :requests
  get  '/requests/count', to:'requests#requests_count'
  get  '/requests/user', to:'requests#user_requests'
  get  '/requests/user/:request_id', to:'requests#request_data'
  get  '/requests/:request_id', to: 'requests#single_request'
  post '/requests/proposels', to: 'requests#insert_proposels'
  post '/requests/:proposal_id', to: 'requests#select_proposal'
  delete '/requests/:request_id', to: 'requests#remove_request'

  # Omni Auth
  get "/auth/:provider/callback" => "omni_auth#create"
  
  # About
  get '/about', to: 'about#about', :as => :about

  # User
  #get '/users/:id', to: 'users#show', :constraints => { :id => /\d+/ }, :as => :user
  #get '/users/:id', to: 'users#edit', :constraints => { :id => /\d+/ }, :as => :edit_user
  get '/user/:username/work_day', to:'users#get_work_days'
  get '/register', to: 'users#new', :as => :users
  post '/register', to: 'users#create'

  get '/:username', to: 'users#calendar', :as => :calendar
end
