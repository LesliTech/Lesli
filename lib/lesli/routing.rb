=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# ·
module Lesli 
    module Routing 

        def self.login path=""

            # Load dedicated mounting routes for devise from the LesliShield engine
            LesliShield::Routing.mount_login_at(path) if defined?(LesliShield);

            # Load generic yet standard routes if LesliShield is not installed
            if !defined?(LesliShield) && defined?(Devise)
                Rails.application.routes.draw do
                    devise_for(:users, class_name: "Lesli::User", module: :devise) 
                end
            end
        end

        def self.mount
            self.login
            Rails.application.routes.draw do
                root to: "lesli/abouts#welcome", as: :welcome
                mount Lesli::Engine => "/lesli" if defined?(Lesli)
                mount LesliBell::Engine => "/bell" if defined?(LesliBell)
                mount LesliAdmin::Engine => "/admin" if defined?(LesliAdmin)
                mount LesliAudit::Engine => "/audit" if defined?(LesliAudit)
                mount LesliBabel::Engine => "/babel" if defined?(LesliBabel)
                mount LesliMailer::Engine => "/mailer" if defined?(LesliMailer)
                mount LesliShield::Engine => "/shield" if defined?(LesliShield)
                mount LesliPapers::Engine => "/papers" if defined?(LesliPapers)
                mount LesliSupport::Engine => "/support" if defined?(LesliSupport)
                mount LesliSecurity::Engine => "/security" if defined?(LesliSecurity)
                mount LesliCalendar::Engine => "/calendar" if defined?(LesliCalendar)
                mount LesliDashboard::Engine => "/dashboard" if defined?(LesliDashboard)
            end
        end

        def self.mount_routes_for lesli_engine
            lesli_engine::Engine.routes.draw do

                # Dashboard alias
                root to: "dashboards#show"

                # Dashboard management
                resource :dashboard, only: [:show, :edit]

                # 
                get "up" => "/rails/health#show"
            end
        end

        def self.mount_dashboard_for lesli_engine
            self.mount_routes_for(lesli_engine)
        end
    end 
end
