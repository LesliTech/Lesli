=begin
Copyright (c) 2023, all rights reserved.

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

class User::RegistrationService < ApplicationLesliServices

    def initialize(resource)
        @resource = resource
    end

    def confirm

        if resource.blank?
            failures.push(I18n.t("core.shared.messages_warning_user_not_found")) 
            return self
        end

        # confirm the user
        resource.confirm

        # force token deletion so we are sure nobody will be able to use the token again
        resource.update(confirmation_token: nil)

        # send a welcome email to user as is confirmed
        UserMailer.with(user: resource).welcome.deliver_later

        # initialize user dependencies
        resource.after_confirmation_user

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
        allow_multiaccount = Rails.application.config.lesli.dig(:security, :allow_multiaccount)

        # create new account for the new user only if multi-account is allowed
        if allow_multiaccount == true
            account = Account.create({
                user: resource,            # set user as owner of his just created account
                company_name: "",           # temporary company name
                status: :active             # account is active due user already confirmed his email
            })
        end

        # if multi-account is not allowed user belongs to the first account in instance
        if allow_multiaccount == false
            account = Account.first
        end

        # add user to his own account
        resource.account = account

        # add owner role to user only if multi-account is allowed
        if allow_multiaccount == true
            resource.user_roles.create({ role: account.roles.find_by(name: "owner") })
        end

        # add profile role to user only if multi-account is allowed
        if allow_multiaccount == false
            # Assigning default role if defined in account settings
            # Otherwise, the default role is "limited"
            default_role_id = account.settings.find_by(:name => "default_role_id")&.value
                
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
