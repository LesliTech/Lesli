Rails.application.routes.draw do

    devise_for :users
    devise_scope :user do

        get "/login" => "users/sessions#new"
        get "/logout" => "devise/sessions#destroy"
        get "/register" => "users/registrations#new"
        get "/password" => "users/passwords#new"

        authenticated  do
            root to: 'cloud_lesli/dashboards#simple'
        end

        unauthenticated do
            root to: 'websites#landing'
        end
        
    end

    authenticated :user do

        resources :websites
        resources :accounts
        resources :account_plans

        #mount TestEngine::Engine => "/testengine"
        #mount CloudTeam::Engine => "/team"
        #mount CloudPanel::Engine => "/panel"
        mount CloudLesli::Engine => "/lesli"

    end

end
