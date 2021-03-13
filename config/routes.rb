require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root to: "home#index"

  authenticate :user, lambda { |u| Rails.env.development? || u.superadmin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { sessions: "sessions" }

  devise_scope :user do
    get "login", to: "devise/sessions#new"
  end

  ActiveAdmin.routes(self)

  get :switch_lang, to: 'application#switch_lang'

  get "/pages/:page" => "pages#show", as: :page

  resources :offers
  resources :inquiries
  resources :device_tokens, only: :create

  concern :accountable do
    get :give_time, on: :member
  end

  resources :organizations, concerns: :accountable, except: :destroy do
    member do
      post :set_current
    end
  end

  resources :users, concerns: :accountable, except: :destroy, :path => "members" do
    collection do
      get 'manage'
    end
  end

  resources :transfers, only: [:create, :new] do
    member do
      put :delete_reason
    end
  end

  match "multi/step/:step", to: "multi_transfers#step", via: [:get, :post], as: :multi_transfers_step
  post "multi/create", to: "multi_transfers#create", as: :multi_transfers_create

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
      get "transfer_list"
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

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
