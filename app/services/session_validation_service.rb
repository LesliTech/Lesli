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

class SessionValidationService
    def initialize(resource)
        @resource = resource
    end

    def valid?
        return respond_with_error(I18n.t("devise.errors.custom.confirmation_required")) unless self.confirmed?
        return true
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
end