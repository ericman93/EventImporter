Calendar::Application.routes.draw do
  #resources :events
  #resources :users

  post '/authenticate', to: 'permissions#authenticate'
  get '/login', to: 'permissions#login', :as => :login
  get '/logout', to: 'permissions#logout', :as => :logout

  get '/users/:id', to: 'users#show', :constraints => { :id => /\d+/ }, :as => :user
  get '/users/:id', to: 'users#edit', :constraints => { :id => /\d+/ }, :as => :edit_user

  get '/calendar/:email', to: 'users#calendar', :constraints => { :email => /.*/ }, :as => :calendar
  get '/user/:email/work_day', to:'users#get_work_days', :constraints => { :email => /.*/ }

  get '/settings', to:'users#settings', :as => :settings
  post '/user/work_days', to:'users#save_work_days'
  
  get '/events/:email', to: 'events#user_events', :constraints => { :email => /.*/ }
  #get '/requests/:request_id', to: 'events#user_requests_events'
  
  post '/calendarapi/insert', to: 'calendar_api#insert'
  
  get '/requests', to:'requests#requests', :as => :requests
  get  '/requests/count', to:'requests#requests_count'
  get  '/requests/user', to:'requests#user_requests'
  post '/requests/insert_proposels', to: 'requests#insert_proposels'
  post '/requests/:proposal_id', to: 'requests#select_proposal'
  delete '/requests/:request_id', to: 'requests#remove_request'
  
  get '/about', to: 'about#about', :as => :about


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
