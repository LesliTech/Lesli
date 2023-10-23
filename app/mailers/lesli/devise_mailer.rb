module Lesli
    class DeviseMailer < ApplicationLesliMailer

        default(template_path: "lesli/emails/devise_mailer")

        def confirmation_instructions(user, token, opts = {})

            # defaults for new accounts/users
            email_template = "confirmation_instructions"
            email_subject = I18n.t("core.users/confirmations.mailer_email_verification")

            # # custom email and subject if user is changin his email address
            # if !record.unconfirmed_email.blank?
            #     email_template = "update_email_confirmation_instructions"
            #     email_subject = I18n.t("core.users/confirmations.mailer_confirmation_instructions_subject")
            # end

            # Depending on wheter there is a new user or they are changing their email, 
            # one or another field will be used
            email_recipient = user.unconfirmed_email || user.email

            # email parameters
            params = {
                url: "/confirmation?confirmation_token=#{token}"
            }

            # send email
            email(
                params,
                to: email_recipient, 
                subject: email_subject,
                template_name: email_template
            )
        end
    end
end
