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

class DeviseMailer < Devise::Mailer
    def confirmation_instructions(record, token, opts = {})

        @data = @data.merge({
            url: "/confirmation?confirmation_token=#{token}",
            user: {
                full_name: record.full_name,
                unconfirmed_email: record.unconfirmed_email
            }
        })

        mail(
            to: email_address_with_name(record.unconfirmed_email, record.full_name), 
            subject: I18n.t("core.users/confirmations.mailer_confirmation_instructions_subject")
        )
    end
end
