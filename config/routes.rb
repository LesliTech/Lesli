Rails.application.routes.draw do

    devise_for :users,
    :controllers => { 
        :registrations => "users/registrations",
        :sessions => "users/sessions"
    },
    :path => "",
    :path_names => {
        :sign_in  => 'login',
        :sign_out => 'logout',
        :sign_up  => 'register',
        :password => 'password',
        :confirmation => 'confirmation'
    }

    authenticated :user do

        root to: "cloud_lesli/dashboards#simple", as: :root_authenticated

        mount CloudLesli::Engine => "/lesli"
        mount CloudTeam::Engine => "/team"
        #mount CloudKb::Engine => "/kb"

        resource :accounts

    end

    root to: "websites#landing", as: :root_unauthenticated
    root to: "websites#landing"

end
