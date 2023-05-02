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

module RoutesApp
    def self.extended(router)
        router.instance_exec do


            # Alternative logins
            resource :mfa,  only: [:show, :update]
            resource :otp,  only: [:show, :create, :update]
            resource :pass, only: [:show, :create, :update]

            # Invitation requests - users ask to join an account
            #resource :invite, only: [:show, :create]

            # Initial settings for account
            resource :onboarding, only: [:show, :create]

            # Administration area for core settings
            scope :administration do

                # show account information by default
                root to: "accounts#show", as: :root_administration

                # standard user profile
                resource :profile, only: [:show] do
                    scope module: :profile do

                        # subscriptions to web push notifications
                        resources :webpushes, only: [:index, :create]

                        # current user notifications
                        resources :notifications, only: [:index, :update]

                        # current user subscriptions management
                        resources :subscriptions, only: [:index] do
                            collection do
                                get :options
                            end
                        end
                    end

                end

                # account management
                resource :account, only: [:show, :update] do
                    scope module: :account do

                        # account files - attached files to account
                        resources :files, only: [:index, :show, :new, :create, :destroy]

                        # account global settings
                        resources :settings, only: [:index, :show, :create, :destroy, :update] do
                            collection do
                                get :options
                                get :security
                                get :date_time
                                get :branding
                                get :theme
                            end
                        end

                        # integration tokens
                        resources :integrations, only: [:index, :new, :create, :destroy]

                        # general geographic locations
                        resources :locations, only: [:index, :show, :create]

                        # task management and scheduling - not yet implemented
                        resources :cronos

                        # system currencies 
                        resources :currencies, only: [:index, :show, :new, :create] do
                            scope module: :currency do

                                # exchange rates management and conversor
                                resources :exchange_rates

                            end
                        end

                    end

                    # extensions to the users methods
                    collection do
                        get :options
                    end
                end

                # User administration
                resources :users, only: [:index, :show, :update, :create, :destroy] do

                    # extensions to the user methods
                    scope module: :user do

                        # sessions management
                        resources :sessions, only: [:index, :destroy]

                        # assign and remove roles to users 
                        resources :roles, only: [:create, :destroy]

                        # shortcuts
                        resources :shortcuts, only: [:index, :create, :update, :destroy]

                        # auth providers
                        resources :auth_providers, only: []

                        #
                        resources :settings, only: [:create]

                        # request password change
                        post :passwordrequest

                        # reset password (generate random)
                        post :passwordreset

                        # Remove all user access :lock
                        post :revokeaccess

                        # close all user sessions
                        post :logout

                        # user impersonate - disabled by default
                        get  :become

                    end

                    # extensions to the users methods
                    collection do
                        get :options
                        get :list
                    end
                end



                # Descriptors for roles
                resources :descriptors, only: [:index, :show, :edit, :create, :update] do
                    scope module: :descriptor do
                        resources :privileges, only: [:index, :create, :destroy]
                    end
                    collection do 
                        get :list
                    end
                end 

                # roles & privileges management
                resources :roles, only: [:index, :show, :edit, :update, :create, :destroy] do
                    scope module: :role do
                        resources :privileges, only: [:index]
                        resources :activities, only: [:index]
                        resources :descriptors, only: [:index, :create, :destroy]
                    end
                    collection do
                        get :list
                        get :options
                    end
                end

                # template generators
                namespace :template do
                    resources :documents do
                        collection do
                            get :options
                        end
                        scope :resources do
                            member do
                                post :generate
                            end
                        end
                    end
                    resources :audience_documents do
                        collection do
                            get :options
                        end
                        member do
                            scope :resources do
                                post :generate_file
                            end
                        end
                    end
                    resources :variables do
                        collection do
                            get :options 
                        end
                    end
                    resources :mappings
                end

                # general system controllers and actions
                resources :system_controllers, only: [:index] do 
                    collection do
                        get :options 
                    end
                end 

            end

            resource :about, only: [:show]

            get "dashboard", to: "abouts#dashboard"

        end
    end
end
