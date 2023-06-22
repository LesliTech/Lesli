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
class Role::ActivitiesController < ApplicationLesliController
    before_action :set_role, only: [:index]

    # @return [HTML|JSON] HTML view for listing all activities associated to a *role*
    # @description Retrieves and returns all the activities associated to a *Role*.
    # The HTTP request has to specify wheter the HTML or the JSON text should be rendered
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.http.get(`127.0.0.1/administration/roles/1/activities.json`);
    def index
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role

                respond_with_successful(Role::Activity.index(@role, @query))
            end
        end
    end

    # @return [Json] Json that contains all the information needed to create a new role_activity
    # @description Retrieves and retuns all the information needed to create a new role_activity,
    #     including the list of companies and contacts.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.http.get('127.0.0.1/house/options/projects')
    def options
        respond_with_successful(Role::Activity.options(current_user, @query))
    end
    
    private
    # @return [void]
    # @description Sets the requested user based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_role
    #     puts @role
    #     # This will either display nil or an instance of Role
    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end
end
