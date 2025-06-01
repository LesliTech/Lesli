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

module Lesli
    class ApplicationLesliMailer < ActionMailer::Base

        # Set a dynamic template according to the engine that is sending the email
        default(template_path: Lesli.config.mailer.dig(:templates))

        #after_action :log_mail_requests

        def initialize

            super

            @app = {}
            @custom = {}
            @params = {}
        end

        def build_url(path, params = {})
            default_url = Rails.application.config.action_mailer.default_url_options
            host = default_url[:host].to_s.sub(/\Ahttps?:\/\//, "")
            scheme = default_url[:protocol]&.delete(":") || "http"

            URI::Generic.build(
                scheme: scheme,
                host: host,
                port: default_url[:port],
                path: path,
                query: params.to_query.presence
            ).to_s
        end

        protected

        def email(params={}, user:nil, to:, subject:, template_name:) 

            @params = @params.merge(params)

            build_app_from_params(params)

            mail(
                to: to, 
                subject: subject,
                template_name: template_name
            )
        end


        private

        def build_app_from_params(params)

            @app[:host] = build_url("/")
            @app[:company] = {
                id: 0,
                name: "",
                tag_line: "",
            }

            return if params[:user].blank? || params[:user].class.name != "Lesli::User"

            @app[:company] = {
                id: params[:user].account.id,
                name: params[:user].account.name,
                #tag_line: params[:user].account.company_tag_line,
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

        def log_mail_requests title="email_sent", payload=nil

            if payload.blank?
                payload = {
                    subject: self.message.subject,
                    to: self.message.to
                }
            end

            if defined? LesliMailer
            end
            # TODO: Save template path and view used within the email
            Account::Log.log_email(
                "#{self.class.to_s}/#{self.action_name}", 
                self.action_name, 
                title, 
                payload
            )

        end

    end
end
