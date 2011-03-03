Givey::Application.routes.draw do

  namespace(:admin){ resources :mturks }

  resources :mturks

  resources :altruists, :only => [:show, :index]
  resources :donations do
    collection do
      get :callback
      get :skip
    end
  end

  resources :causes, :as => "npos", :controller => "npos" do
    collection do
      get :top
    end
  end
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

    collection do
      get :end_round
      get :scores_unlocked
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
  match "/cc2" => "home#cc2"
  match "/beta_test" => "home#beta_test", :as => "beta_test"
  match "/r/:token"  => "home#referral"
  
  match '/about'  => "home#about", :as => "about" 
  match '/terms'  => "home#terms", :as => "terms" 
  match '/privacy'  => "home#privacy", :as => "privacy" 
  match '/faq'  => "home#faq", :as => "faq" 
  match '/noieplease' => "home#noieplease", :as => "noieplease" 
  get "home/index"
  root :to => "home#index"
end
