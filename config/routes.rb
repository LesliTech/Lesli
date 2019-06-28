Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    get "/login" => "devise/sessions#new", :as => :new_user_session_root

    authenticated  do
      #root to: 'lesli#dashboard'
    end

    unauthenticated do
      #root to: 'frontend#index'
    end
  end

end
