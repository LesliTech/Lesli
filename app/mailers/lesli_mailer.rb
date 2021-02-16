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

class LesliMailer < ApplicationLesliMailer

    def simple
        user = params[:user]
        build_data_from_params(params)
        mail(to: email_address_with_name(user.email, user.full_name), subject: "TEST: simple email")
    end

    def multiple
        user = params[:user]
        
        recipients = build_recipients_from_params(params)
        mail(
            subject: "welcome email",
            bcc: recipients[:bcc], 
            cc: recipients[:cc], 
            to: recipients[:to]
        )
    end

end
