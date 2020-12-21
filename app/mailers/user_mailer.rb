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

    # Sends an welcome email when new user is created
    # @data = {
    #     full_name: "Luis Donis"
    # }
    #def welcome_email(user, subject="Welcome to My Awesome Site")
    def welcome_email
        
        @user = params[:user]
        @subject = params[:subject]
        @data = {}
        # rails 6.1
        # mail(to: email_address_with_name(user.email, user.full_name), subject: subject)
        mail(to: @user.email, subject: @subject)
    end

end
