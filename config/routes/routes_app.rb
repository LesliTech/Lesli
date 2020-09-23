=begin

Lesli

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
            authenticated :user do

                # profiles
                resource :profile

                scope :lock do

                    # account management
                    resource  :account do
                        scope module: :account do
                            resources :locations
                        end
                    end

                    # user maintenance
                    resources :users do
                        collection do
                            get :options
                        end
                        member do
                            get "resources/become/:id",     to: "users#become"
                        end
                    end

                    # roles management
                    resources :roles do
                        scope module: :role do
                            resources :privileges
                        end
                        member do
                            scope :resources do
                                post :restore_default_privileges
                                post :update_default_privileges
                            end
                        end
                    end
                end

                scope :panel do

                    # template generators
                    namespace :template do
                        resources :documents do
                            collection do
                                get :options
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

                # Lesli version
                get "version", to: "abouts#version"
                get "dashboard", to: "abouts#dashboard"
                get "system-requirements", to: "abouts#system_requirements"

            end

        end
    end
end
