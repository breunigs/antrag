Antrag::Application.routes.draw do
  root :to => "motions#kingslanding"

  # common actions
  resources :motions

  # attachments
  get "/motions/:id/add_attachment" => "motions#add_attachment", :as => :motion_add_attachment
  get "/motions/:id/remove_attachment/:attachment" => "motions#remove_attachment"
  post "/motions/:id/store_attachment" => "motions#store_attachment", :as => :motion_store_attachment

  # comments
  post "/motions/:id/store_comment" => "motions#store_comment", :as => :motion_store_comment

  # toggles
  get "/motions/:id/toggle_motion_top" => "motions#toggle_motion_top", :as => :toggle_motion_top
  get "/motions/:id/toggle_motion_fin_granted" => "motions#toggle_motion_fin_granted", :as => :toggle_motion_fin_granted
  get "/motions/:id/toggle_motion_fin_deducted" => "motions#toggle_motion_fin_deducted", :as => :toggle_motion_fin_deducted

  # other stuff
  resources :referate
  resources :users
  resources :fachschaften
  match "/vote/:fachschaft_id/:motion_id" => "votes#new"

  # session handlung
  match "/login" => "sessions#login"
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/logout" => "sessions#destroy", :as => :logout

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
