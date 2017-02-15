Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users

  devise_scope :user do
    get "login", to: "devise/sessions#new"
  end

  ActiveAdmin.routes(self)

  get "global/switch_lang", as: :switch_lang

  resources :offers do
    collection do
      get :dashboard
    end
  end

  resources :inquiries

  concern :accountable do
    get :give_time, on: :member
  end

  resources :organizations, concerns: :accountable do
    member do
      post :set_current
    end
  end

  resources :users, concerns: :accountable, except: :destroy, :path => "members"

  resources :transfers, only: [:create] do
    member do
      put :delete_reason
    end
  end

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
    end
  end

  resource "statistics" do
    collection do
      get "statistics_global_activity"
      get "statistics_inactive_users"
      get "statistics_demographics"
      get "statistics_last_login"
      get "statistics_without_offers"
      get "statistics_type_swaps"
      get "statistics_all_transfers"
    end
  end

  resource :terms, only: [:show] do
    post :accept
  end

  resources :tags, only: [:index] do
    collection do
      get "alpha_grouped_index"
      get "inquiries"
      get "offers"
    end
  end

end
