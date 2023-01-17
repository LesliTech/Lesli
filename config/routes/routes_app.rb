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

module RoutesApp
    def self.extended(router)
        router.instance_exec do


            # Alternative logins
            resource :mfa,  only: [:show, :update]
            resource :otp,  only: [:show, :create, :update]
            resource :pass, only: [:show, :create, :update]

            # Invitation requests - users ask to join an account
            resource :invite, only: [:show, :create]

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

                        # general feedback
                        resources :issues

                        # system currencies 
                        resources :currencies, only: [:index, :show, :new, :create] do
                            scope module: :currency do

                                # exchange rates management and conversor
                                resources :exchange_rates

                            end
                        end

                    end

                    # account catalog & options
                    collection do
                        get :options
                    end
                end

                # User administration
                resources :users, only: [:index, :show, :update, :create, :destroy] do
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

                    end

                    # user helper resources
                    member do

                        # close sessions of users
                        post :logout

                        # enable/disable user access
                        post :lock

                        # force password reset
                        post :password

                        scope :resources do

                            # user impersonate - disabled by default
                            get  :become

                            # close sessions of users
                            post :logout

                            # enable/disable user access
                            post :lock

                            # force password reset
                            post :password

                        end
                    end

                    collection do
                        get :options
                        get :list
                    end

                    member do
                        scope :actions do

                            # hability to change users email
                            # TODO:
                            #   if new email is not provided, generate a new one
                            #   id + email
                            put :email

                        end
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
                    resources :descriptors, only: [:create, :destroy]
                    scope module: :role do
                        resources :privileges, only: [:index]
                        resources :activities, only: [:index]
                        resources :describers, only: [:index, :create, :destroy]
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

            scope :about do
                get "version", to: "abouts#version"
                get "system-requirements", to: "abouts#system_requirements"
            end

            get "dashboard", to: "abouts#dashboard"

        end
    end
end
