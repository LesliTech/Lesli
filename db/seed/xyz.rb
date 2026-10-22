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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

def create_account_user(account:, email:, role_name:, first_name:, last_name:, password: nil)
    user = Lesli::User.find_or_initialize_by(email: email)
    authentication_enabled =
        user.respond_to?(:password=) &&
        user.respond_to?(:password_confirmation=)
    credentials_created = false

    Lesli::User.transaction do
        user.assign_attributes(
            account: account,
            first_name: first_name,
            last_name: last_name
        )

        # LesliShield installs Devise directly on the Core user model. Checking
        # the model capability keeps this seeder independent from Devise and
        # allows Lesli Core to seed users without an authentication engine.
        if authentication_enabled && user.encrypted_password.blank?
            raise ArgumentError, "A password is required when authentication is enabled" if password.blank?

            user.password = password
            user.password_confirmation = password
            user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
            credentials_created = true
        end

        user.save!

        # Role assignments are owned by LesliShield and should only be created
        # when its concrete join model is available.
        if authentication_enabled && defined?(LesliShield::User::Role)
            role = account.roles.find_by!(name: role_name)
            user.user_roles.find_or_create_by!(role: role)
        end
    end

    if credentials_created
        Termline.success(
            "#{role_name.capitalize} user created successfully with " \
            "email: #{email} and password: #{password}"
        )
    end

    user
end
