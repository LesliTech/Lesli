=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

Rails.application.routes.draw do

  namespace :user do
    resources :logs
  end
  namespace :user do
    resources :requests
  end
    devise_for :users,
    :path => "",
    :path_names => {
        :sign_in  => "login",
        :sign_out => "logout",
        :sign_up  => "register",
        :password => "password",
        :confirmation => "confirmation"
    },
    :controllers => { 
        :registrations => "users/registrations",
        :confirmations => "users/confirmations",
        :passwords => "users/passwords",
        :sessions => "users/sessions"
    }

    get :language, to: "application#switch_locale"

    extend RoutesBuilder
    extend RoutesApp

    authenticated :user do

        mount ActionCable.server  => "/cable"
        mount CloudBell::Engine   => "/bell"   if defined?(CloudBell)
        mount CloudAudit::Engine  => "/audit"  if defined?(CloudAudit)
        mount CloudLesli::Engine  => "/lesli"  if defined?(CloudLesli)
        mount CloudBabel::Engine  => "/babel"  if defined?(CloudBabel)
        mount CloudHouse::Engine  => "/house"  if defined?(CloudHouse)
        mount CloudFocus::Engine  => "/focus"  if defined?(CloudFocus)
        mount CloudNotes::Engine  => "/notes"  if defined?(CloudNotes)
        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudMailer::Engine => "/mailer" if defined?(CloudMailer)

        root to: redirect("/dashboard"), as: :root_authenticated

    end

    mount CloudDispatcher::Engine => "/api" if defined?(CloudDispatcher)

    match "/404", :to => "errors#not_found",             :via => :all
    match "/401", :to => "errors#unauthorized",          :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    root to: "websites#show", as: :root_unauthenticated

end
