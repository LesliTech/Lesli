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

class ApplicationLesliMailer < ActionMailer::Base

    layout "mailer"


    # Set a dynamic template according to the engine that is sending the email
    # this is equivalent to: default template_path: -> { "engine_name/emails" }
    default(

        from: -> {

            instance = Rails.application.config.lesli.dig(:instance)

            # add custom email name for emails sent from www.lesli.cloud
            if instance[:code] == 'lesli_cloud'
                return email_address_with_name(
                    Rails.configuration.lesli.dig(:env, :action_mailer, :default_options_from), 
                    "Lesli"
                )
            end

            Rails.configuration.lesli.dig(:env, :action_mailer, :default_options_from)

        },

        template_path: -> {

            instance = Rails.application.config.lesli.dig(:instance)

            # get class that is executing the mailer
            module_info = self.class.name.split("::")

            # mailers from engines
            if module_info.length > 1
                return "#{ instance[:code] }/emails/#{(module_info[0].underscore)}/#{ module_info[1].underscore }"
            end

            # mailers from core
            return "#{ instance[:code] }/emails/#{ module_info[0].underscore }"

        }

    )

    after_action :log_mail_requests

    def initialize

        super

        # some @email data is defined on: LesliMails/src/partials/data.html
        @custom = {}
        @email = {}
        @data = {}
        @app = {}

    end


    protected


    def build_data_from_params(params, data={})

        # make custom data available in mailer method and mailer template
        @data = @data.merge(data)

        build_app_from_params(params)

        build_customization_from_params(params)

    end

    def build_app_from_params(params)

        @app[:host] = default_url_options[:host]
        @app[:instance] = Rails.application.config.lesli.dig(:instance)
        @app[:company] = {
            id: 0,
            name: "",
            tag_line: "",
        }

        return if params[:user].blank? || params[:user].class.name != "User"

        @app[:company] = {
            id: params[:user].account.id,
            name: params[:user].account.company_name,
            tag_line: params[:user].account.company_tag_line,
        }

    end

    def build_customization_from_params(params)

        instance = Rails.application.config.lesli.dig(:instance)

        # lesli is the code used for the core. If there are no builder engines,
        # the instance namespace is "/"
        instance_path = ""
        instance_path = "#{instance[:code]}/" if instance[:code] != "lesli"

        # using cdn logos by default (testing feature)
        # @custom[:logo] = "#{instance_path}brand/app-logo.svg"
        @custom[:logo] = "https://cdn.lesli.tech/leslicloud/brand/app-logo.png"

        return if params[:user].blank? || params[:user].class.name != "User"

        custom_logo = nil # params[:user].account.files.where(file_type: "app_logo").last

        if custom_logo
            @custom[:logo] = custom_logo.attachment.url if custom_logo.attachment_identifier
            @custom[:logo] = custom_logo.attachment_public.url if custom_logo.attachment_public_identifier
        end

    end

    def build_recipients_from_users(users)
        if users.is_a?(Array)
            users.map { |user| email_address_with_name(user.email, user.full_name) }
        end
    end

    def build_recipients_from_contacts(contacts)
        if contacts.is_a?(Array)
            contacts.map { |contact| email_address_with_name(contact[:email], contact[:name]) }
        end
    end

    def build_recipients_from_emails()
    end


    private


    def log_mail_requests title="email_sent", payload=nil

        if payload.blank?
            payload = {
                subject: self.message.subject,
                to: self.message.to
            }
        end

        # TODO: Save template path and view used within the email
        Account::Activity.log_email(
            "#{self.class.to_s}/#{self.action_name}", 
            self.action_name, 
            title, 
            payload
        )

    end

end
