Rails.application.routes.draw do

    devise_for :users,
    :controllers => { 
        :registrations => "users/registrations",
        :confirmations => "users/confirmations",
        :passwords => "users/passwords",
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

        root to: redirect('/lesli'), as: :root_authenticated

        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudBooks::Engine => "/books" if defined?(CloudBooks)
        mount CloudPanel::Engine => "/panel" if defined?(CloudPanel)
        mount CloudTeam::Engine => "/team" if defined?(CloudTeam)
        mount CloudLock::Engine => "/lock" if defined?(CloudLock)
        mount CloudBell::Engine => "/bell" if defined?(CloudBell)
        mount CloudHelp::Engine => "/help" if defined?(CloudHelp)
        mount CloudKb::Engine => "/kb" if defined?(CloudKb)

        resource :accounts
        resources :translations
        resources :settings

        resources :locks
        namespace :lock do
            resources :roles
            resources :role_overrides
            resources :role_privileges
        end

        scope "admin" do
            resources :users
            namespace :user do
                resources :details
            end
        end

        extend RoutesAssistant
        extend RoutesBell

    end

    root to: "websites#landing", as: :root_unauthenticated
    root to: "websites#landing"

    mount ActionCable.server => '/cable'

end
