Calendar::Application.routes.draw do
  # Auth
  post '/authenticate', to: 'permissions#authenticate'
  get '/login', to: 'permissions#login', :as => :login
  get '/logout', to: 'permissions#logout', :as => :logout

  # User
  get '/users/:id', to: 'users#show', :constraints => { :id => /\d+/ }, :as => :user
  get '/users/:id', to: 'users#edit', :constraints => { :id => /\d+/ }, :as => :edit_user
  get '/calendar/:email', to: 'users#calendar', :constraints => { :email => /.*/ }, :as => :calendar
  get '/user/:email/work_day', to:'users#get_work_days', :constraints => { :email => /.*/ }

  # Settings
  get '/settings', to:'settings#settings', :as => :settings
  get '/settings/work_hours', to:'settings#work_hours'
  get '/settings/web_mails', to:'settings#web_mails'
  patch '/settings/work_hours', to:'settings#save_work_hours'
  
  # Events
  get '/events/:email', to: 'events#user_events', :constraints => { :email => /.+@.+/ }
  get '/events/:id', to: 'events#show', :constraints => { :id => /\d+/ }
  #get '/requests/:request_id', to: 'events#user_requests_events'
  
  # API
  post '/calendarapi/insert', to: 'calendar_api#insert'
  
  # Request
  get '/requests', to:'requests#requests', :as => :requests
  get  '/requests/count', to:'requests#requests_count'
  get  '/requests/user', to:'requests#user_requests'
  post '/requests/insert_proposels', to: 'requests#insert_proposels'
  post '/requests/:proposal_id', to: 'requests#select_proposal'
  delete '/requests/:request_id', to: 'requests#remove_request'
  
  # About
  get '/about', to: 'about#about', :as => :about
end
