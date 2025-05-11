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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Lesli
    class UserRegistrationOperator < Lesli::ApplicationLesliService

        def initialize(current_user)
            @resource = current_user
            @current_user = current_user
        end

        def confirm

            if current_user.blank?
                failures.push(I18n.t("core.shared.messages_warning_user_not_found")) 
                return self
            end

            # confirm the user
            current_user.confirm

            # force token deletion so we are sure nobody will be able to use the token again
            resource.update(confirmation_token: nil)

            # send a welcome email to user as is confirmed
            #UserMailer.with(user: resource).welcome.deliver_later

            # initialize user dependencies
            current_user.after_confirmation_user

        end

        def create_account

            if resource.blank?
                failures.push(I18n.t("core.shared.messages_warning_user_not_found")) 
                return self
            end

            if resource.account
                failures.push(I18n.t("core.users.messages_info_user_already_belongs_to_account")) 
                return self
            end

            # check if instance is for multi-account
            allow_multiaccount = Lesli.config.security.dig(:allow_multiaccount)

            # create new account for the new user only if multi-account is allowed
            if allow_multiaccount === true
                account = Account.create!({
                    user: resource,     # set user as owner of his just created account
                    name: "Lesli",      # temporary company name
                    email: resource.email,
                    status: :active     # account is active due user already confirmed his email
                })
            end

            # if multi-account is not allowed user belongs to the first account in instance
            if allow_multiaccount === false
                account = Account.first
            end

            # add user to his own account
            resource.account = account

            # add owner role to user only if multi-account is allowed
            if allow_multiaccount == true
                #resource.powers.create({ role: account.roles.find_by(name: "owner") })
            end

            # add profile role to user only if multi-account is allowed
            if allow_multiaccount == false
                # Assigning default role if defined in account settings
                # Otherwise, the default role is "limited"
                #default_role_id = account.settings.find_by(:name => "default_role_id")&.value
                    
                if default_role_id.present?
                    resource.user_roles.create({ role: account.roles.find_by(:id => default_role_id)})
                else
                    resource.user_roles.create({ role: account.roles.find_by(name: "limited") })
                end
            end

            # update user :)
            resource.save

            # initialize user dependencies
            resource.after_account_assignation

        end
    end
end
