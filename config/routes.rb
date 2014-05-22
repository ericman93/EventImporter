Calendar::Application.routes.draw do
  #resources :events
  #resources :users

  post '/users/authenticate', to: 'users#authenticate'
  get '/users/login', to: 'users#login', :as => :login
  get '/users/logout', to: 'users#logout', :as => :logout
  get '/users/:id', to: 'users#show', :constraints => { :id => /\d+/ }, :as => :user
  get '/users/:id', to: 'users#edit', :constraints => { :id => /\d+/ }, :as => :edit_user
  get '/calendar/:email', to: 'users#calendar', :constraints => { :email => /.*/ }, :as => :calendar
  get '/users/requests_count', to:'users#requests_count'
  get '/users/requests', to:'users#requests', :as => :requests
  post '/users/requests_partial', to:'users#requests_partial'
  
  get '/events/:email', to: 'events#user_events', :constraints => { :email => /.*/ }
  get '/requests/:request_id', to: 'events#user_requests_events'
  
  post '/calendarapi/insert', to: 'calendar_api#insert'
  post '/calendarapi/insertTempEvent', to: 'calendar_api#send_user_event_options'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:key => "value", 
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
