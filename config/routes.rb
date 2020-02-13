Rails.application.routes.draw do

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

        resource :account

        mount ActionCable.server  => "/cable"
        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudBabel::Engine  => "/babel"  if defined?(CloudBabel)
        mount CloudPanel::Engine  => "/panel"  if defined?(CloudPanel)
        mount CloudLesli::Engine  => "/lesli"  if defined?(CloudLesli)
        mount CloudHouse::Engine  => "/house"  if defined?(CloudHouse)
        mount CloudTeam::Engine   => "/team"   if defined?(CloudTeam)
        mount CloudLock::Engine   => "/lock"   if defined?(CloudLock)
        mount CloudBell::Engine   => "/bell"   if defined?(CloudBell)
        mount CloudHelp::Engine   => "/help"   if defined?(CloudHelp)
        mount CloudKb::Engine     => "/kb"     if defined?(CloudKb)

        root to: redirect('/lesli'), as: :root_authenticated if defined?(CloudLesli)
        root to: "dashboards#empty", as: :root_authenticated if !defined?(CloudLesli)

    end

    root to: "websites#landing", as: :root_unauthenticated

end
