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
    module Router
        def self.login(router, path = "")
            # Prefer LesliShield’s dedicated routes if installed
            if defined?(LesliShield)
                # Make LesliShield::Router accept router too (recommended)
                LesliShield::Router.mount_login_at(router, path)
            elsif defined?(Devise)
                router.devise_for :users, class_name: "Lesli::User", module: :devise
            end
        end

        def self.mount(router, path = "")
            login(router, path)

            router.root to: "lesli/abouts#welcome", as: :welcome

            router.mount Lesli::Engine => "/lesli" if defined?(Lesli)
            router.mount LesliBell::Engine => "/bell" if defined?(LesliBell)
            router.mount LesliAdmin::Engine => "/admin" if defined?(LesliAdmin)
            router.mount LesliAudit::Engine => "/audit" if defined?(LesliAudit)
            router.mount LesliBabel::Engine => "/babel" if defined?(LesliBabel)
            router.mount LesliMailer::Engine => "/mailer" if defined?(LesliMailer)
            router.mount LesliShield::Engine => "/shield" if defined?(LesliShield)
            router.mount LesliPapers::Engine => "/papers" if defined?(LesliPapers)
            router.mount LesliSupport::Engine => "/support" if defined?(LesliSupport)
            router.mount LesliSecurity::Engine => "/security" if defined?(LesliSecurity)
            router.mount LesliCalendar::Engine => "/calendar" if defined?(LesliCalendar)
            router.mount LesliContacts::Engine => "/contacts" if defined?(LesliContacts)
            router.mount LesliDashboard::Engine => "/dashboard" if defined?(LesliDashboard)
        end

        # Shared default routes for any Lesli engine
        def self.mount_lesli_engine_routes(router)
            router.root to: "dashboards#show"

            # Load dashboard resources
            router.resource :dashboard, only: %i[show edit]

            # Load Lesli items
            router.namespace :items do

                # Load item tasks
                router.resources :tasks, only: %i[index update create]
            end

            # Optional: health check inside engine scope (pick a consistent path)
            router.get "up", to: "/rails/health#show"
        end
    end
end
