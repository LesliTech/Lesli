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

            # Alternative logins - magic links
            resource :otp,  only: [:show, :new, :create]
            resource :pass, only: [:show, :new, :create]

            authenticated :user do

                # Lesli core administration components
                scope :administration do

                    root to: "accounts#show", as: :root_administration

                    # Lesli user profile
                    resource :profile, only: [:show]

                    # account management
                    resource :account, only: [:show] do
                        scope module: :account do
                            resources :files, only: [:index, :show, :new, :create]
                            resources :settings, only: [:index, :show, :new, :create]
                            resources :integrations, only: [:index, :show, :new, :create]
                            resources :locations, only: [:index, :show, :create]
                            resources :currencies do
                                resources :exchange_rates
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
                        resources :variables
                        resources :mappings
                    end

                    #
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

            # Access Codes
            namespace :ma do
                # Magic Links
                resource :ml, only: [:show, :create]
                # Magic Code or OTP
                resources :mcs
            end

        end
    end
end
