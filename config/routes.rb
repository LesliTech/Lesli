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

        root to: "cloud_lesli/dashboards#default", as: :root_authenticated

        mount CloudDriver::Engine => "/driver"
        mount CloudLesli::Engine => "/lesli"
        mount CloudBooks::Engine => "/books"
        mount CloudPanel::Engine => "/panel"
        mount CloudTeam::Engine => "/team"
        mount CloudBell::Engine => "/bell"
        mount CloudHelp::Engine => "/help"
        mount CloudKb::Engine => "/kb"

        resource :accounts

    end

    root to: "websites#landing", as: :root_unauthenticated
    root to: "websites#landing"

end
