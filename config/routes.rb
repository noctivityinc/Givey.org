Givey::Application.routes.draw do
  resources :donations
  resources :npos
  resources :games do
    member do
      post :paypal_redirect
      get :in_progress
      get :share
      post :duel
      get :winners
      get :complete
      get :redo
      get :sub
    end
    get :needs_friends, :on => :collection
  end
  resource :payment_notifications, :only => :create

  match "/auth/:provider/callback" => "sessions#create"
  match 'access_denied', :to => "sessions#access_denied", :as => "access_denied"
  match "/signout" => "sessions#destroy", :as => :signout

  resources :admin, :only => :index
  namespace :admin do
    resources :npos
    resources :categories
    resources :backgrounds
  end

  get "home/index"
  root :to => "home#index"
end
