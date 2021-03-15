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

class UserMailer < ApplicationLesliMailer
    include Devise::Controllers::UrlHelpers

    def welcome
        user = params[:user]
        build_data_from_params(params, {
            url: "/",
            user: {
                full_name: user.full_name
            }
        })
        mail(to: @email[:to], subject: "welcome email")
    end


    # Send confirmation instruction email with the link and token to validate the account
    def invitation_instructions
    
        user = params[:user]
        token = user.generate_password_reset_token

        build_data_from_params(params, {
            url: "/password/edit?reset_password_token="+token,
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)
            }
        })
        
        mail(to: @email[:to], subject: "You have been invited")

    end


    # Send confirmation instruction email with the link and token to validate the account
    def confirmation_instructions
        user = params[:user]
        token = user.confirmation_token
        @data = @data.merge({
            url: "/confirmation?k="+token,
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)
            }
        })

        mail(
            to: email_address_with_name(user.email, user.full_name), 
            subject: "Welcome to Lesli! please confirm your account"
        )
    end


    # Send a link with a reset password token
    def reset_password_instructions
        user = params[:user]
        token = params[:token]
        @data = @data.merge({
            url: "/password/edit?reset_password_token=#{token}",
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)
            }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: I18n.t("core.users/passwords.mailer_password_reset_instructions"))
    end

    def magic_link
        user = params[:user]
        token = params[:token]
        build_data_from_params(params, {
                url: "/ma/mls?user_id=#{user.id}&token=#{token}",
                user: {
                        full_name: user.full_name
                }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "works")
    end

end
