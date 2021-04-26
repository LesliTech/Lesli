=begin
Copyright (c) 2021, all rights reserved.

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

class UserValidationService
    
    def initialize(resource)
        @resource = resource
    end

    def valid?
        return LC::Response.service(false, {"message"=>I18n.t("devise.errors.custom.confirmation_required")}) unless self.confirmed?

        return LC::Response.service(false, {"message"=>I18n.t("core.users/sessions.the_user_has_no_assigned_role")}) if self.roles_empty?

        return LC::Response.service(false, {"message"=>I18n.t("deutscheleibrenten.users/sessions.role_access_denied")}) unless self.active_roles?

        LC::Response.service(true)
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
        @resource.roles.select(:active).each do |role|

            break if role[:active]

            @resource.logs.create({
                title: "session_creation_failed",
                description: "user_has_no_active_role"
            })

            return false

        end

        return true
        
    end
end
