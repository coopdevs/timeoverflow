Timeoverflow::Application.routes.draw do
  # devise_for :users
  # mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  concern :joinable do
    member do
      post :join
      post :leave
    end
  end

  resources :offers, concerns: :joinable
  resources :inquiries, concerns: :joinable


  concern :accountable do
    get :give_time, on: :member
  end

  resources :organizations, concerns: :accountable

  resources :users, concerns: :accountable

  resources :transfers, only: [:create]

  match '/login',  to: 'sessions#create', via: :post
  match '/logout', to: 'sessions#destroy', via: :post

  resource :sessions, only: [:create, :destroy]

  post '/users/sign_in', to: 'sessions#create'

  resource "report" do
    collection do
      get "user_list"
      get "cat_with_users"
    end
  end


  root to: "application#index"

end
