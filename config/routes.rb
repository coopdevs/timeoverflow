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

  resources :organizations, except: [:new, :create, :destroy], concerns: :accountable do
    member do
      post :set_current
    end
  end
  get :select_organization, to: 'organizations#select_organization'

  resources :users, concerns: :accountable, except: :destroy, :path => "members" do
    collection do
      get 'manage'
    end
  end

  resources :transfers, only: [:new, :create] do
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
      get "download_csv_detailed"
      get "download_all"
    end
  end

  resource "statistics" do
    collection do
      get :global_activity
      get :inactive_users
      get :demographics
      get :last_login
      get :without_offers
      get :type_swaps
      get :all_transfers
    end
  end

  resource :terms, only: [:show] do
    post :accept
  end

  resources :tags, only: [:index] do
    collection do
      get :alpha_grouped_index
    end
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
