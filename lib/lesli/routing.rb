module Lesli 
    module Routing 
        def self.mount_login
            mount_login_at()
        end
        def self.mount_login_at path=""
            Rails.application.routes.draw do
                devise_for :users, class_name: "Lesli::User", module: :devise,
                :path => path,
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
            end
        end
    end 
end
