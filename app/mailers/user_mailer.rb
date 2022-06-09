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

class UserMailer < ApplicationLesliMailer
    include Devise::Controllers::UrlHelpers

    # not used mailer
    def welcome
        user = params[:user]
        build_data_from_params(params, {
            url: "/",
            user: {
                full_name: user.full_name
            }
        })

        I18n.with_locale(user.locale) do
            mail(
                to: email_address_with_name(user.email, user.full_name),
                subject: I18n.t("core.users.mailer_subject_welcome")
            )
        end
    end


    # not used mailer
    def first_access
        user = params[:user]
        token = params[:token]
        build_data_from_params(params, {
                url: "/pass?t=#{token}",
                user: {
                    full_name: user.full_name
                }
        })

        mail(
            to: email_address_with_name(user.email, user.full_name),
            subject: 'I18n.t("core.passes.mailer_login_link_instructions")'
        )
    end


    # Send confirmation instruction email with the link and token to validate the account
    def invitation_instructions

        user = params[:user]
        token = user.generate_password_reset_token

        build_data_from_params(params, {
            url: "/password/edit?reset_password_token="+token,
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)||[]
            }
        })

        I18n.with_locale(user.locale) do
            mail(
                to: email_address_with_name(user.email, user.full_name),
                subject: I18n.t("core.users.mailer_subject_you_have_been_invited")
            )
        end
    end


    # not used mailer
    # Send confirmation instruction email with the link and token to validate the account
    def confirmation_instructions
        user = params[:user]
        token = user.confirmation_token
        build_data_from_params(params, {
            url: "/confirmation?k="+token,
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)||[]
            }
        })

        mail(
            to: email_address_with_name(user.email, user.full_name),
            subject: I18n.t("core.users.mailer_welcome_please_confirm_your_account")
        )
    end

    # Send a link with a reset password token
    def reset_password_instructions
        user = params[:user]
        token = params[:token]
        build_data_from_params(params, {
            url: "/password/edit?reset_password_token=#{token}",
            user: {
                full_name: user.full_name,
                roles: user.roles.map(&:name)||[]
            }
        })

        I18n.with_locale(user.locale) do
            mail(
                to: email_address_with_name(user.email, user.full_name),
                subject: I18n.t("core.users/passwords.mailer_password_reset_instructions")
            )
        end
    end


    #
    def pass_instructions
        user = params[:user]
        token = params[:token]
        build_data_from_params(params, {
                url: "/pass?t=#{token}",
                user: {
                    full_name: user.full_name
                }
        })
        mail(
            to: email_address_with_name(user.email, user.full_name),
            subject: I18n.t("core.passes.mailer_login_link_instructions")
        )
    end


    #
    def otp_instructions
        user = params[:user]
        build_data_from_params(params, {
                token: params[:token],
                user: {
                    full_name: user.full_name
                }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "your one time password")
    end

    def mfa_instructions
        user = params[:user]
        build_data_from_params(params, {
                token: params[:token],
                user: {
                    full_name: user.full_name
                }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "MFA Code")
    end
end
