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


    # This mailer is used in two different scenarios:
    #       1. User register to create a new account
    #       2. User wants to update his email address
    # Due email update or new email is the same for Devise
    # we have to use different strategies to know if the users is trying to create a new account
    # or update his email address
    def confirmation_instructions(record, token, opts = {})

        # defaults for new accounts/users
        email_template = "new_account_confirmation_instructions"
        email_subject = I18n.t("leslimails.devise_mailer.view_text_subject_new_account")

        # custom email and subject if user is changin his email address
        if !record.unconfirmed_email.blank?
            email_template = "update_email_confirmation_instructions"
            email_subject = I18n.t("core.users/confirmations.mailer_confirmation_instructions_subject")
        end

        # Depending on wheter there is a new user or they are changing their email, one or another field will be used
        recipient_email = record.unconfirmed_email || record.email

        self.build_data_from_params({}, {
            url: "/confirmation?confirmation_token=#{token}",
            user: {
                full_name: record.full_name,
                unconfirmed_email: recipient_email
            }
        })

        mail(
            to: email_address_with_name(recipient_email, record.full_name), 
            subject: email_subject,
            template_name: email_template
        )

    end
end
