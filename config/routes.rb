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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# Mount the devise at the deefault path
# TODO:
#   The user can define the mount path for the auth framework
#   using: "Lesli::Routing.mount_login_at('auth')" so, later
#   we will must to check if devise is already mounted before
#   to call this method.
Lesli::Routing.mount_login


# Mount the necessary resources Lesli needs to work properly
Lesli::Engine.routes.draw do

    resource :about, only: [:show]

    resources :users, only: [] do
        collection do
            get :list
        end
    end

    resources :roles, only: [] do 
        collection do
            get :list
        end
    end

    resources :system_controllers, only: [:index]

    get :language, to: "application#language"
end
