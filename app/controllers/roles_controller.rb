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

class RolesController < ApplicationLesliController    
    before_action :set_role, only: [:update, :destroy]

    def index
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(Role.index(current_user, @query)) 
            }
        end
    end

    def show
        respond_to do |format|
            format.html {  }
            format.json { 
                set_role

                return respond_with_not_found unless @role
                
                Role.log_activity_show(current_user, @role)

                @role = @role.show

                respond_with_successful(@role) 
            }
        end
    end

    def new
    end

    def edit
    end

    def create
        role = Role.new(role_params)
        role.account = current_user.account

        if role.save
            respond_with_successful(role)

            Role.log_activity_create(current_user, role)

            role.initialize_role_privileges
        else
            respond_with_error(role.errors.full_messages)
        end
    end

    def update
        return respond_with_not_found unless @role
        
        old_attributes = @role.attributes

        if @role.update(role_params)
            new_attributes = @role.attributes

            respond_with_successful(@role)

            Role.log_activity_update(current_user, @role, old_attributes, new_attributes)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @role
        
        if @role.destroy
            respond_with_successful

            Role.log_activity_destroy(current_user, @role)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
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
        @role = current_user.account.roles.find_by(id: params[:id])
    end

    def role_params
        params.require(:role).permit(
            :name,
            :active,
            :object_level_permission
        )
    end
end
