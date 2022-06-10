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

class UserValidationService

    def initialize(resource)
        @resource = resource
    end

    def valid?
        return LC::Response.service(false, {"message"=>I18n.t("devise.errors.custom.confirmation_required")}) unless self.confirmed?

        return LC::Response.service(false, {"message"=>I18n.t("core.users/sessions.the_user_has_no_assigned_role")}) if self.roles_empty?

        return LC::Response.service(false, {"message"=>I18n.t("deutscheleibrenten.users/sessions.role_access_denied")}) unless self.active_roles?

        LC::Response.service(true)
    end


    # validates if password meet with the minimum password requirements
    # this settings are stored in the account_settings table
    def password_complexity(password)

        return LC::Response.service(false, 'error_password_cannot_be_blank') if password.blank?

        # remove all the special characters for easy validations of some rules
        password_string_no_special = password.gsub(/[^0-9A-Za-z]/, '')

        # database keys with the parameters to validate
        password_values = [
            'password_expiration_time_days',
            'password_enforce_complexity',
            'password_special_char_count',
            'password_lowercase_count',
            'password_uppercase_count',
            'password_minimum_length',
            'password_digit_count'
        ].map do |setting_name|
            "name = '#{setting_name}'"
        end

        # get password settings from the database
        if @resource.account

            # if user is already registered
            password_settings = @resource.account.settings.where(password_values.join(" or "))

        else

            # for new accounts just take the first account in the database
            password_settings = Account.first.settings.where(password_values.join(" or "))

        end

        # error array, so we return all the errors found in the password
        password_settings_errors = []

        password_settings.each do |settings|

            # exit validations if password complexity is not enabled
            if settings[:name] == 'password_enforce_complexity' and settings[:value] != "1"
                password_settings_errors = []
                break
            end

            # check if the password has te minimum number of special characters required
            if settings[:name] == 'password_special_char_count'

                # this regex removes all "normal" letters and numbers leaving special characters
                if settings[:value].to_i > password.scan(/[^0-9A-Za-z]/).length
                    password_settings_errors.push('error_password_special_char_count')
                end

            end

            # check if the password has te minimum number of lowercase letters required
            if settings[:name] == 'password_lowercase_count'

                if settings[:value].to_i > password_string_no_special.scan(/[^0-9A-Z]/).length
                    password_settings_errors.push('error_password_lowercase_count')
                end

            end

            # check if the password has te minimum number of uppercase letters required
            if settings[:name] == 'password_uppercase_count'

                if settings[:value].to_i > password_string_no_special.scan(/[^0-9a-z]/).length
                    password_settings_errors.push('error_password_uppercase_count')
                end

            end

            # check if the password has te minium number of numbers required xD
            if settings[:name] == 'password_digit_count'

                if settings[:value].to_i > password_string_no_special.scan(/[^A-Za-z]/).length
                    password_settings_errors.push('error_password_digit_count')
                end

            end

            # check if the password has te minimum size required
            if settings[:name] == 'password_minimum_length'

                if settings[:value].to_i > password.length
                    password_settings_errors.push('error_password_minimum_length')
                end

            end

        end

        return LC::Response.service(false, password_settings_errors) if password_settings_errors.length > 0
        return LC::Response.service(true)

    end

    private

    def confirmed?

        # check if user is already confirmed
        unless @resource.confirmed?

            # save a invalid credentials log for the requested user
            @resource.logs.create({
                title: "session_creation_failed",
                description: "email_not_confirmed"
            })

            return false

        end

        return true

    end

    def roles_empty?

        # check if user has roles assigned
        if @resource.roles.empty?

            @resource.logs.create({
                title: "session_creation_failed",
                description: "user_has_no_assigned_role"
            })

            return true

        end

        return false

    end

    def active_roles?

        # check user has at least one active role before authorize the sign-in request
        unless (@resource.roles.map {|role| role.active}.include? true)
            @resource.logs.create({
                title: "session_creation_failed",
                description: "user_has_no_active_role"
            })

            return false
        end

        return true
    end
end
