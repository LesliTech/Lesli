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

class UserRegistrationService
    
    def initialize(resource)
        @resource = resource
    end

    def create_account

        return LC::Response.service(false, "Not valid user found") if @resource.blank?
        return LC::Response.service(false, "User already belongs to accoutn") if @resource.account

        # check if instance is for multi-account
        allow_multiaccount = Rails.application.config.lesli_settings["configuration"]["security"]["allow_multiaccount"]

        # create new account for the new user only if multi-account is allowed
        if allow_multiaccount == true
            account = Account.create({ 
                user: @resource,        # set user as owner of his just created account
                company_name: "",       # temporary company name
                status: "active"        # account is active due user already confirmed his email
            })
        end

        # if multi-account is not allowed user belongs to the first account in instance
        if allow_multiaccount == false
            account = Account.first
        end

        # add user to his own account
        @resource.account = account

        # add owner role to user
        @resource.user_roles.create({ role: account.roles.find_by(name: "owner")})

        # update user :)
        @resource.save

        # initialize user with necessary data to work with the platform
        @resource.initialize_user

        LC::Response.service(true)

    end

    private

end
