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


    # Send confirmation instruction email with the link and token to validate the account
    def invitation_instructions
        user = params[:user]
        token = user.generate_password_reset_token

        @data = @data.merge({
            url: "/password/edit?reset_password_token="+token,
            user: {
                full_name: user.full_name
            }
        })

        mail(
            to: email_address_with_name(user.email, user.full_name), 
            subject: "You have been invited"
        )
    end


    # Send confirmation instruction email with the link and token to validate the account
    def confirmation_instructions
        user = params[:user]
        token = user.confirmation_token
        @data = @data.merge({
            url: "/confirmation?k="+token,
            user: {
                full_name: user.full_name
            }
        })

        mail(
            to: email_address_with_name(user.email, user.full_name), 
            subject: "Welcome to Lesli! please confirm your account"
        )
    end



    def welcome
        user = params[:user]
        @data = @data.merge({
            url: "/password/edit?reset_password_token",
            user: {
                full_name: user.full_name
            }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "welcome email")
    end

    def reset_password_instructions
        user = params[:user]
        token = params[:token]
        @data = @data.merge({
            url: "/password/edit?reset_password_token=#{token}",
            user: {
                full_name: user.full_name
            }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "password reset instructions")
    end

end
