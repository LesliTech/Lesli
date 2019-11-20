Rails.application.routes.draw do

  namespace :lock do
    resources :roles
  end
  namespace :bell do
    resources :emails
  end
  namespace :bell do
    resources :messages
  end
  namespace :bell do
    resources :notifications
  end
  resources :bells
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

        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudBooks::Engine => "/books" if defined?(CloudBooks)
        mount CloudPanel::Engine => "/panel" if defined?(CloudPanel)
        mount CloudTeam::Engine => "/team" if defined?(CloudTeam)
        mount CloudLock::Engine => "/lock" if defined?(CloudLock)
        mount CloudBell::Engine => "/bell" if defined?(CloudBell)
        mount CloudHelp::Engine => "/help" if defined?(CloudHelp)
        mount CloudKb::Engine => "/kb" if defined?(CloudKb)

        #mount CloudCourier::Engine => "/courier"
        #mount CloudLesli::Engine => "/lesli"

        resource :accounts

    end

    root to: "websites#landing", as: :root_unauthenticated
    root to: "websites#landing"

end
