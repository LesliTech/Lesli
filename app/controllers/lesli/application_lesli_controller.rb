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
module Lesli
    class ApplicationLesliController < ApplicationController
        include Interfaces::Application::Responder
        include Interfaces::Application::Requester
        # include Interfaces::Application::Logger

        protect_from_forgery with: :exception

        before_action :set_locale
        # before_action :authorize_request
        # before_action :authorize_privileges
        before_action :set_helpers_for_request
        before_action :set_helpers_for_account
        before_action :set_customization

        # after_action  :log_user_requests

        layout "lesli/layouts/application-lesli"

        attr_reader :query

        # Rescue from "ParameterMissing" when using required params
        # in controllers
        rescue_from ActionController::ParameterMissing do |_e|
            respond_with_error("Missing params")
        end

        private

        # Set default query params for:
        #   pagination
        def set_helpers_for_account
            # @account is only for html requests
            return unless request.format.html?

            @lesli[:revision] = 0
            @lesli[:company] = {}
=begin
            @lesli[:revision] = 0 #Lesli::System.revision()
            @lesli[:notifications] = 0 #Courier::Bell::Notification.count(current_user, true)
            @lesli[:tasks] = 0 #Courier::Focus::Task.count(current_user)
            @lesli[:tickets] = 0 #Courier::Help::Ticket.count(current_user)
            @lesli[:shortcuts] = [] # current_user.shortcuts.select(:id, :name, :url)

            # default customization, set on before_action :set_customization hook
            @lesli[:customization] = { :logo => "image.svg", :color_primary => "#1f7ce3" }

            return @lesli if current_user.account.blank?

            # add company information (account)
            @lesli[:company] = {
                id: current_user.account.id,
                name: current_user.account.company_name,
                tag_line: current_user.account.company_tag_line,
                phone_number_1: current_user.account.phone_number_1,
                public_email: current_user.account.public_email,
                address: current_user.account.address,
                website: current_user.account.website
            }

            @lesli[:settings] = {
                datetime: Rails.application.config.lesli.dig(:configuration, :datetime),
                currency: (Rails.application.config.lesli.dig(:configuration, :currency) || {})
                    .merge({ locale: Rails.application.config.lesli.dig(:env, :default_locale) }),
            }

            # set user information
            @lesli[:current_user] = {
                id: current_user.id,
                email: current_user.email,
                full_name: current_user.full_name,
                roles: current_user.roles.map(&:name),
                abilities: current_user.abilities_by_controller,
                max_object_level_permission: current_user.roles.map(&:object_level_permission).max,
                settings: current_user.settings.map { |s| { name: s.name, value: s.value } }
            }

            #
            @lesli[:providers] = {
                firebase: {
                    config: Rails.application.credentials.dig(:providers, :firebase, :web),
                    user: Rails.application.credentials.dig(:providers, :firebase, :user)
                },
                google_translate: Rails.application.credentials.dig(:providers, :google_translate)
            }
=end
        end

        # set customization only for lesli_cloud instance
        def set_customization
            # @account is only for html and pdf requests
            return unless request.format.html? || request.format.pdf?

            # return unless Lesli.instance[:code] == "lesli_cloud"

            @lesli[:customization] = {}

            logos = {}
            # logo_identifiers = Account::File.file_types.keys
            # custom_logos = current_user.account.files.where("file_type in (?)", logo_identifiers).order(id: :desc).all
            # logo_identifiers.each do |logo_identifier|
            #     custom_logo = custom_logos.find { |logo| logo.file_type == logo_identifier}
            #     next unless custom_logo

            #     custom_logo_url = "/administration/account/files/#{custom_logo.id}"
            #     custo_logo_url = custom_logo.attachment_url if custom_logo.attachment_identifier
            #     custom_logo_url = custom_logo.attachment_public_url if custom_logo.attachment_public_identifier

            #     logos[logo_identifier.to_sym] = custom_logo_url
            # end
            @lesli[:customization][:logos] = logos

            colors = {}
            # color_identifiers = ::Account::Setting.theme_settings_keys
            # custom_colors = current_user.account.settings.where("name in (?)", color_identifiers).all
            # color_identifiers.each do |color_identifier|
            #     custom_color = custom_colors.find { |color| color.name == color_identifier}
            #     next unless custom_color

            #     colors[color_identifier.to_sym] = custom_color.value
            # end
            @lesli[:customization][:colors] = colors
        end
    end
end
