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

module RoutesApp
    def self.extended(router)
        router.instance_exec do
            authenticated :user do

                # profiles
                resource  :profile

                scope :settings do

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

                end

                # Lesli version
                get "version", to: "abouts#version"
                get "dashboard", to: "abouts#dashboard"
                get "system-requirements", to: "abouts#system_requirements"

            end

        end
    end
end
