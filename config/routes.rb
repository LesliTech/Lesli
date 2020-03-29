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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

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

    get :language, to: 'settings#language'

    authenticated :user do

        resource  :account
        resources :settings

        mount ActionCable.server  => "/cable"
        mount CloudBell::Engine   => "/bell"   if defined?(CloudBell)
        mount CloudLock::Engine   => "/lock"   if defined?(CloudLock)
        mount CloudPanel::Engine  => "/panel"  if defined?(CloudPanel)
        mount CloudLesli::Engine  => "/lesli"  if defined?(CloudLesli)
        mount CloudBabel::Engine  => "/babel"  if defined?(CloudBabel)
        mount CloudHouse::Engine  => "/house"  if defined?(CloudHouse)
        mount CloudFocus::Engine  => "/focus"  if defined?(CloudFocus)
        mount CloudDriver::Engine => "/driver" if defined?(CloudDriver)
        mount CloudDispatcher::Engine => "/api" if defined?(CloudDispatcher)

        extend RoutesHaus if defined?(CloudHaus)

        root to: redirect('/lesli'), as: :root_authenticated if defined?(CloudLesli)
        root to: "dashboards#empty", as: :root_authenticated if !defined?(CloudLesli)

    end

    root to: redirect('/login'), as: :root_login_unauthenticated if defined?(CloudHaus)
    root to: "websites#landing", as: :root_unauthenticated

end
