=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

Rails.application.routes.draw do

    extend RoutesBuilder
    extend RoutesEngines
    extend RoutesApp

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
        :sessions => "users/sessions",
        #:omniauth_callbacks => "users/oauth",
    }

    get :language, to: "application#language"

    match "/404", :to => "errors#not_found",             :via => :all
    match "/401", :to => "errors#unauthorized",          :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    authenticated :user do
        root to: redirect("/dashboard"), as: :root_authenticated
    end

    unauthenticated :user do
        root to: "websites#show", as: :root_unauthenticated
    end
end
