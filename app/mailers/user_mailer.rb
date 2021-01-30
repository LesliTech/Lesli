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

    # Sends an welcome email when new user is created
    # @data = {
    #     full_name: "Luis Donis"
    # }
    def welcome_email(user, subject="Welcome")
        mail(to: email_address_with_name(user.email, user.full_name), subject: subject)
    end

    # fix this
    def confirmation_instructions(pa1,pa2,pa3)
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
