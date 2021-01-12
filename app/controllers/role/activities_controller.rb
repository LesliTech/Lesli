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
