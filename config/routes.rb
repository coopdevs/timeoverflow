Timeoverflow::Application.routes.draw do
  get "global/switch_lang", as: :switch_lang
  get "tags/index"

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

  resources :users, concerns: :accountable, except: :destroy, path: "members"

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
    end
  end

  resource :terms, only: [:show] do
    post :accept
  end

  resource :tags, only: [:index] do
    collection do
      get "alpha_grouped_index"
      get "alpha_grouped_destroy"
      get "alpha_grouped_rename"
      get "inquiries"
      get "offers"
      get "destroy_inquiries"
      get "destroy_offers"
      get "rename_inquiries"
      get "rename_offers"
      get "posts_with"
      post "rename"
      post "destroy"
    end
  end

end
