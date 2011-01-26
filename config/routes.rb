Givey::Application.routes.draw do
  resources :donations
  resources :npos
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
  end

  get "home/index"
  root :to => "home#index"
  match "/:token", :to => "home#show" 


end
