=begin

Copyright (c) 2022, all rights reserved.

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

class UsersValidator < ApplicationLesliValidator

    def validate 
        confirmed?()
        roles_empty?()
        active_roles?()
    end

    private

    def confirmed?

        # check if user is already confirmed
        unless @resource.confirmed?

            # save a invalid credentials log for the requested user
            @resource.logs.create({
                title: "session_creation_failed",
                description: "email_not_confirmed"
            })

            return false

        end

        return true

    end

    def roles_empty?

        # check if user has roles assigned
        if @resource.roles.empty?

            @resource.logs.create({
                title: "session_creation_failed",
                description: "user_has_no_assigned_role"
            })

            return true

        end

        return false

    end

    def active_roles?

        # check user has at least one active role before authorize the sign-in request
        unless (@resource.roles.map {|role| role.active}.include? true)
            @resource.logs.create({
                title: "session_creation_failed",
                description: "user_has_no_active_role"
            })

            return false
        end

        return true
    end
end
