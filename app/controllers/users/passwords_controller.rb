# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController

    # Sends an email with a token, so the user can reset their password
    def create

        if params[:user].blank?
            #Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email")
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        if params[:user][:email].blank?
            #Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email")
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        user = Lesli::User.find_by(:email => params[:user][:email])

        if user.blank?
            # Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email", {
            #     email: (params[:user][:email] || "")
            # })
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        unless user.active
            # user.logs.create({title: "password_creation_failed", description: "user_not_active"})
            # Account::Activity.log("core", "/password/create", "password_creation_failed", "user_not_active")
            return respond_with_error(I18n.t("core.users/passwords.messages_danger_inactive_user"))
        end

        token = user.generate_password_reset_token

        #user.logs.create({ title: "password_creation_successful" })

        begin
            Lesli::DeviseMailer.reset_password_instructions(user, token).deliver_now
            respond_with_successful
        rescue => exception
            #Honeybadger.notify(exception)
            respond_with_error(exception.message)
        end
    end

    def update
        super do |resource|

            # check if password update was ok
            if resource.errors.empty?

                # reset password expiration due the user just updated his password
                if resource.has_expired_password?
                    resource.update(password_expiration_at: nil)
                end

                resource.logs.create(title: "password_reset_successful")

                return respond_with_successful

            else

                resource.logs.create(title: "password_reset_error") if resource.id

                return respond_with_error(resource.errors.full_messages.to_sentence)

            end

        end
    end
end
