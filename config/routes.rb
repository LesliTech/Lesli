Rails.application.routes.draw do

  namespace :core do
    resources :attachments
  end
  devise_for :users
  devise_scope :user do
    get "/login" => "devise/sessions#new", :as => :new_user_session_root

    authenticated  do
      root to: 'websites#home'
    end

    unauthenticated do
      root to: 'websites#home'
    end
  end

  #extend Onboarding

end
