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

            unauthenticated :user do

                # Alternative logins - magic links
                resource :otp,  only: [:show, :new, :create]
                resource :pass, only: [:show, :new, :create]
                resource :onboarding, only: [:show, :create]

            end

            authenticated :user do

                resource  :account, only: [:new, :create, :show]

                # Lesli core administration components
                scope :administration do

                    root to: "accounts#show", as: :root_administration

                    # Lesli user profile
                    resource :profile, only: [:show] do
                        scope module: :profile do
                            resources :notifications, only: [:index, :update]
                        end

                    end

                    # account management
                    resource :account, only: [:show] do
                        scope module: :account do
                            resources :files, only: [:index, :show, :new, :create]
                            resource :settings do
                                collection do
                                    get :options
                                end
                            end
                            resources :integrations, only: [:index, :show, :new, :create]
                            resources :locations, only: [:index, :show, :create]
                            resources :cronos
                            resources :currencies do
                                resources :exchange_rates
                                collection do
                                    get :list
                                end
                            end
                        end
                        member do
                            scope :resources do
                                delete :company_logo
                            end
                        end
                    end

                    # user maintenance
                    resources :users, only: [:index, :show, :update, :create, :destroy] do

                        scope module: :user do
                            # user sessions
                            resources :sessions, only: [:index, :destroy]

                            # user role assignments
                            resources :roles, only: [:create, :destroy]
                        end

                        # user helper resources
                        member do
                            scope :resources do
                                get  :become
                                post :logout
                                post :lock
                                post :password
                            end
                        end

                        collection do
                            get :options
                            get :list
                        end

                        member do
                            scope :actions do
                                put :email
                            end
                        end

                    end

                    # roles & privileges management
                    resources :roles do
                        scope module: :role do
                            resources :privileges
                            resources :activities
                            collection do
                                get "/activities/options",                   to: "/role/activities#options"
                            end
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
                        resources :variables
                        resources :mappings
                    end

                    resources :workflows do
                        member do
                            get "actions/options",          to: "workflow/actions#options"
                        end
                        collection do
                            post "list" => :index
                            get  "associations/options",    to: "workflow/associations#options"
                            get "/resources/transition-options/:cloud_object_name/:cloud_object_id", to: "workflows#transition_options"
                        end
                        scope module: :workflow do
                            resources :associations
                            resources :actions
                            resources :statuses
                        end
                    end

                end

                get "version", to: "abouts#version"
                get "dashboard", to: "abouts#dashboard"
                get "system-requirements", to: "abouts#system_requirements"

            end

        end
    end
end
