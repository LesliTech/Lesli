Rails.application.routes.draw do

  devise_scope :user do
    get "sign_in" => "users/sessions#new", :as => :new_user_session
  end

  #root to: 'frontend#index'

end
