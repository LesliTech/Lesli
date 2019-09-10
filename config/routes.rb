Rails.application.routes.draw do

    devise_for :users, controllers: { 
        registrations: "users/registrations",
        confirmations: "users/confirmations",
        sessions: "users/sessions"
    }

    devise_scope :user do

        get "/login" => "users/sessions#new"
        get "/logout" => "users/sessions#destroy"
        get "/register" => "users/registrations#new"
        get "/password" => "users/passwords#new"

        authenticated do
            root to: "cloud_lesli/dashboards#simple", as: :root_authenticated
        end

        unauthenticated do
            root to: "websites#landing", as: :root_unauthenticated
            root to: "websites#landing"
        end
        
    end

    authenticated :user do

        get "/account" => "accounts#new"

        resources :accounts
        mount CloudLesli::Engine => "/lesli"
        mount CloudTeam::Engine => "/team"

    end

end
