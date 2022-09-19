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

class OnboardingsController < ApplicationLesliController

    def privileges 
        {
            show: []
        }
    end

    # GET /onboarding
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless current_user.account
                return respond_with_successful({
                    account: current_user.account,
                    account_settings: current_user.account.settings
                })
            end
        end
    end


    # POST /onboarding
    def create

        account = Account.find_by_id(current_user.account.id)

        if account.update(onboarding_params[:account]) && account.settings.update(current_user, onboarding_params[:account_settings])
            account.active!
            respond_with_successful(account)
        else
            respond_with_error(account.errors.full_messages.to_sentence)
        end

    end


    # POST /onboarding/invite
    def invite

        # check if request has an email to create the user
        return respond_with_error(I18n.t("core.users.messages_danger_not_valid_email_found")) if invite_user_params[:email].blank?

        # register the new user
        user = User.new({
            :active => true,
            :email => invite_user_params[:email],
            :detail_attributes => invite_user_params[:detail_attributes]
        })

        # assign a random password
        user.password = Devise.friendly_token

        # enrol user to my own account
        user.account = current_user.account

        # users created through the administration area does not need to confirm their accounts
        # instead we send a password reset link, so they can have access to the platform
        user.confirm

        if user.save

            # role validation - if new user does not have any role assigned assign limited role
            user.user_roles.create({ role: current_user.account.roles.find_by(:name => "limited") }) if user.roles.blank?

            # saving logs with information about the creation of the user
            user.logs.create({ description: "user_created_at " + LC::Date.to_string_datetime(LC::Date.datetime) })
            user.logs.create({ description: "user_created_by " + current_user.id.to_s })
            user.logs.create({ description: "user_created_with_role " + user.user_roles.first.roles_id.to_s })

            User.log_activity_create(current_user, user)

            respond_with_successful(user)

            begin
                # users created through the administration area does not need to confirm their accounts
                # instead we send a password reset link, so they can have access to the platform
                UserMailer.with(user: user).invitation_instructions.deliver_now
            rescue => exception
                Honeybadger.notify(exception)
                user.logs.create({ description: "user_creation_email_failed " + exception.message })
            end

        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end
    end


    def onboarding_params
        accepted_params = params.fetch(:onboarding, {}).permit(
            account: [
                :status,
                :company_name,
                :company_name_legal,
                :company_tag_line,
                :country,
                :address,
                :region,
                :website,
                :phone_number_1,
                :phone_number_2,
                :phone_number_3,
                :phone_number_4,
                :public_email,
                :github,
                :twitter,
                :youtube,
                :linkedin,
                :facebook
            ],
            account_settings: [
                :password_enforce_complexity,
                :password_minimum_length,
                :password_expiration_time_days,
                :password_special_char_count,
                :password_uppercase_count,
                :password_lowercase_count,
                :password_digit_count,
                :datetime_time_zone,
                :datetime_start_week_on,
                :datetime_format_date,
                :datetime_format_time,
                :datetime_format_date_time,
                :datetime_format_date_words,
                :datetime_format_date_time_words,
            ]
        )

        accepted_params[:account] = {} unless accepted_params[:account]
        accepted_params[:account_settings] = {} unless accepted_params[:account_settings]

        return accepted_params
    end

    def invite_user_params
        params.require(:invite).permit(
            :email,
            detail_attributes: {}
        )
    end

end
