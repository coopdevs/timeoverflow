Timeoverflow::Application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'


  resources :categories do
    collection do
      get :global, action: :index, filter: :global
      get :local, action: :index, filter: :local
      get :root, action: :index, filter: :root
    end
  end
  resources :organizations
  resources :users do
    get :change_password, on: :member
  end
  resources :sessions, only: [:new, :create, :destroy]

  # # match '/signup',  to: 'users#new'
  match '/sign_in',  to: 'sessions#new', via: :post
  match '/sign_out', to: 'sessions#destroy', via: :delete

  # get "log_in" => "sessions#new", :as => "log_in"
  # get "log_out" => "sessions#destroy", :as => "log_out"

  # devise_for :users


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

  # match '(*any)' => "application#index"


  root to: "application#index"

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
