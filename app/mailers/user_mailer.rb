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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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

    #
    def mfa_instructions
        user = params[:user]
        build_data_from_params(params, {
                # add a dash at the middle of the code
                token: params[:token],#.chars.each_slice(3).map(&:join).join("-"),
                user: {
                    full_name: user.full_name
                }
        })
        mail(to: email_address_with_name(user.email, user.full_name), subject: "MFA Token")
    end
end
