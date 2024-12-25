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
    class ApplicationLesliController < ApplicationController
        include Lesli::AuthorizationInterface
        include Lesli::CustomizationInterface
        include Lesli::ResponderInterface
        include Lesli::RequesterInterface
        include Lesli::LoggerInterface

        protect_from_forgery with: :exception

        before_action :set_path
        before_action :set_locale
        before_action :authorize_request if defined?(LesliShield)
        before_action :authorize_privilege if defined?(LesliSecurity)
        before_action :set_customizer
        before_action :set_requester
        after_action  :log_requests if defined?(LesliAudit)

        layout "lesli/layouts/application-lesli"

        # Rescue from "ParameterMissing" when using required params
        # in controllers
        rescue_from ActionController::ParameterMissing do |_e|
            respond_with_error("Missing params")
        end
    end
end
