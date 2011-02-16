Givey::Application.routes.draw do

  resources :altruists, :only => [:show, :index] 
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
  match '/friends'  => "friends#index"

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
  match '/header'  => "home#header"
  get "home/index"
  root :to => "home#index"


end
