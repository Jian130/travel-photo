Travelphoto::Application.routes.draw do
  #TODO: change sessions url to login all the time

  get "signout" => "sessions#destroy", :as => :signout
  get "signin" => "sessions#new", :as => :signin
  get "signup" => "authentications#new", :as => :signup
  get "register" => "users#new", :as => :register

  match "/auth/:provider/callback" => "authentications#create"
  match "/auth/failure" => "authentications#failure"
  match "/posts/upload" => "posts#upload", :as => "preview"
  match "/home" => "posts#index"
  match '/locations/autocomplete' => 'locations#autocomplete'

  #scope 'users' do
  resources :users do #, :path => 'register'
    member do
      get :following, :followers
    end
  end
  #end
  # resources :users do
	# get :following, :on => :member
	# get :follwers, :on => :member
  # end

  resources :relationships, :only => [:create, :destroy]
  #resources :users, :only => [:index, :show, :create]
  #resources :likes, :only => [:create]
  resources :translations
  #resources :comments
  resources :sessions
  resources :locations, :only => [:show]
  resources :posts do
    resources :comments, :likes
  end
  resources :comments, :only => [:create] do
    resources :likes
  end
  #resource :photo, :only => [:show, :destroy]
  resources :profiles, :only => [:show, :edit, :update, :destroy]
  root :to => "pages#home"
  match "/:username" => "users#show"
  
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
  # match ':controller(/:action(/:id(.:format)))'
end
