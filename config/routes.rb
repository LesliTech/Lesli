Rails.application.routes.draw do

  resources :websites

  devise_for :users
  devise_scope :user do

    get "/login" => "users/sessions#new", :as => :new_user_session_root
    get "/logout" => "devise/sessions#destroy", :as => :destroy_user_session_root

    authenticated  do
      root to: 'websites#home'
    end

    unauthenticated do
      root to: 'websites#home'
    end
  end

  #extend Onboarding

end
