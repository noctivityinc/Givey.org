Givey::Application.routes.draw do

  match "/altruists/"  => "altruists#index"
  
  resources :donations do
    collection do
      get :callback
    end
  end

  resources :npos
  resources :users do
    resources :friends
    member do
      get :needs_friends
    end
  end

  get 'sparks/reset'
  resources :sparks do
    member do
      get :defriend
    end
  end

  match "/auth/:provider/callback" => "sessions#create"
  match 'access_denied', :to => "sessions#access_denied", :as => "access_denied"
  match "/signout" => "sessions#destroy", :as => :signout

  resources :admin, :only => :index
  namespace :admin do
    resources :npos
    resources :categories
    resources :backgrounds
    resources :beta_testers
    resources :questions
  end

  match "/not_yet" => "home#not_yet"
  match "/beta_test" => "home#beta_test", :as => "beta_test"
  get "home/index"
  root :to => "home#index"
  match "/:token", :to => "home#show"


end
