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

class UserRegistrationService
    
    def initialize(resource)
        @resource = resource
    end

    def create_account

        return LC::Response.service(false, I18n.t("core.shared.messages_warning_user_not_found")) if @resource.blank?
        return LC::Response.service(false, I18n.t("core.users.messages_info_user_already_belongs_to_account")) if @resource.account

        # check if instance is for multi-account
        allow_multiaccount = Rails.application.config.lesli_settings["security"]["allow_multiaccount"]

        # create new account for the new user only if multi-account is allowed
        if allow_multiaccount == true
            account = Account.create({ 
                user: @resource,            # set user as owner of his just created account
                company_name: "",           # temporary company name
                status: "onboarding"        # account is active due user already confirmed his email
            })
        end

        # if multi-account is not allowed user belongs to the first account in instance
        if allow_multiaccount == false
            account = Account.first
        end

        # add user to his own account
        @resource.account = account

        # add owner role to user
        @resource.user_roles.create({ role: account.roles.find_by(name: "owner")})

        # update user :)
        @resource.save

        # initialize user with necessary data to work with the platform
        @resource.initialize_user

        # initialize user dependencies
        @resource.initialize_user_after_confirmation

        LC::Response.service(true)

    end

    # @return [User] User record.
    # @description This method find and update a user with external party authentication provider data.
    #       If the user did not exist is created with the data received from the auth provider.
    def oauth(auth_params)
        auth_provider = auth_params[:provider]
        auth_provider = "Google" if auth_params[:provider] == "google_oauth2"

        if @resource
            # set a new provider for and existent user
            @resource.auth_providers.find_or_create_by({
                provider: auth_provider,
                uid: auth_params[:uid],
                id_token: auth_params[:id_token],
                access_token: auth_params[:access_token],
                refresh_token: auth_params[:refresh_token],
            })

            return @resource
        end

        # find the user by provided uid
        user_auth_provider = User::AuthProvider.find_by({
            provider: auth_provider,
            uid: auth_params[:uid],
        })

        @resource = user_auth_provider.user if user_auth_provider

        unless @resource

            # create user with provided data
            @resource = User.new({
                active: true,
                email: auth_params[:info][:email],
                password: Devise.friendly_token,
                detail_attributes: {
                    first_name: auth_params[:info][:first_name],
                    last_name: auth_params[:info][:last_name],
                }
            })

            # if new account, launch account onboarding in another thread,
            # so the user can continue with the registration process
            Thread.new { self.create_account } if @resource.account.blank?

            @resource.confirm

            if @resource.save

                # create provider for this user
                @resource.auth_providers.create({
                    provider: auth_provider,
                    uid: auth_params[:uid],
                    id_token: auth_params[:id_token],
                    access_token: auth_params[:access_token],
                    refresh_token: auth_params[:refresh_token],
                })

                # saving logs with information about the creation of the user
                @resource.logs.create({ description: "user_created_at " + LC::Date.to_string_datetime(LC::Date.datetime) })

                User.log_activity_create(@resource, @resource)
            end
        end

        @resource

    end

    private

end
