=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
        email_template = "account-new"
        email_subject = I18n.t("core.users/confirmations.mailer_email_verification")

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
