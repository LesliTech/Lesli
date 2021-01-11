=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

Rails.application.routes.draw do

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
        mount CloudTeam::Engine   => "/team"   if defined?(CloudTeam)
        mount CloudBell::Engine   => "/bell"   if defined?(CloudBell)
        mount CloudHelp::Engine   => "/help"   if defined?(CloudHelp)
        mount CloudText::Engine   => "/text"   if defined?(CloudText)
        mount CloudAudit::Engine  => "/audit"  if defined?(CloudAudit)
        mount CloudLesli::Engine  => "/lesli"  if defined?(CloudLesli)
        mount CloudBabel::Engine  => "/babel"  if defined?(CloudBabel)
        mount CloudHouse::Engine  => "/house"  if defined?(CloudHouse)
        mount CloudFocus::Engine  => "/focus"  if defined?(CloudFocus)
        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudMailer::Engine => "/mailer" if defined?(CloudMailer)
        mount CloudThings::Engine => "/inventory" if defined?(CloudThings)
        mount CloudFederation::Engine => "/federation" if defined?(CloudFederation)
        mount CloudDevelopment::Engine => "/development" if defined?(CloudDevelopment)

        root to: redirect("/dashboard"), as: :root_authenticated

    end

    mount CloudDispatcher::Engine => "/api" if defined?(CloudDispatcher)

    match "/404", :to => "errors#not_found",             :via => :all
    match "/401", :to => "errors#unauthorized",          :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    root to: "websites#show", as: :root_unauthenticated

end
