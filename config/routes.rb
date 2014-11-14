Timeoverflow::Application.routes.draw do
  get 'global/switch_lang'
  get 'tags/index'

  devise_for :users

  ActiveAdmin.routes(self)

  concern :joinable do
    member do
      post :join
      post :leave
    end
  end

  resources :offers, concerns: :joinable do
    collection do
      get :dashboard
    end
  end
  resources :inquiries, concerns: :joinable


  concern :accountable do
    get :give_time, on: :member
  end

  resources :organizations, concerns: :accountable

  resources :users, concerns: :accountable, except: :destroy, :path => "members"

  resources :transfers, only: [:create]

  resources :documents

  resources :members, only: [:destroy] do
    member do
      put :toggle_manager
      put :toggle_active
    end
  end

  resource "report" do
    collection do
      get "user_list"
      get "offer_list" => :post_list, type: "offer"
      get "inquiry_list" => :post_list, type: "inquiry"
      get "statistics"
    end
  end

  resource :terms, only: [:show] do
    post :accept
  end

  resource :tags, only: [:index] do
    collection do
      get "alpha_grouped_index"
      get "inquiries"
      get "offers"
      get "posts_with"
    end
  end

end
