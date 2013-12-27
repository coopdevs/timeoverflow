Timeoverflow::Application.routes.draw do
  devise_for :users, controllers: {
    sessions: "sessions"
  }

  ActiveAdmin.routes(self)
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

  resources :documents

  resource "report" do
    collection do
      get "user_list"
      get "cat_with_users"
    end
  end


  root to: "application#index"

  resource :terms, only: [:show] do
    post :accept
  end


end
