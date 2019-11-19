Rails.application.routes.draw do

  namespace :lock do
    resources :user_details
  end
  namespace :lock do
    resources :user_privileges
  end
  namespace :lock do
    resources :user_role_privileges
  end
  namespace :lock do
    resources :user_roles
  end
  resources :locks
  resources :settings
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

        # mount engine if CloudEngine folder exists

        mount CloudDriver::Engine => "/driver" unless defined?(CloudDriver)


=begin
        mount CloudCourier::Engine => "/courier"
        
        mount CloudLesli::Engine => "/lesli"
        mount CloudBooks::Engine => "/books"
        mount CloudPanel::Engine => "/panel"
        mount CloudTeam::Engine => "/team"
        mount CloudLock::Engine => "/lock"
        mount CloudBell::Engine => "/bell"
        mount CloudHelp::Engine => "/help"
        mount CloudKb::Engine => "/kb"
        mount CloudDev::Engine => "/dev"
=end
        resource :accounts

    end

    root to: "websites#landing", as: :root_unauthenticated
    root to: "websites#landing"

end
