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
module Workflow
    class ActionMailer < ApplicationLesliMailer

        def generic
            user = params[:user]
            subject = params[:subject]
            data = params[:data]
            options = params[:options]

            mail(
                to: email_address_with_name(user["email"], (user["name"] || user["email"])), 
                subject: subject,
                options: options
            )
        end
    end
end
