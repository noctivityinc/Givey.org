Givey::Application.routes.draw do


  resources :donations
  resources :npos

  resources :sparks
  resources :games do
    member do
      get :in_progress
      put :share
      post :duel
      get :winners
      get :complete
      get :redo
    end
    get :needs_friends, :on => :collection
  end

  resources :candidates do
    collection do
      get :story
      put :submit_story
      get :not_the_winner
    end
  end
  match "/c/:token"  => "candidates#new"

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
