=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

module Lesli
    class ResourceOperator
        DEVISE_CONTROLLERS = %w[
            users/registrations users/sessions users/passwords users/confirmations
        ].freeze

        HOST_INTERNAL_CONTROLLERS = %w[
            rails action_mailbox active_storage view_components
            turbo/native/navigation lesli/abouts
        ].freeze

        # Scan routes from the main application and installed engines,
        # then register their controllers and actions as Lesli resources.
        # Repeated runs retain existing resource IDs.
        def register!
            # Register the complete catalog in one transaction so a failed
            # action does not leave a partially updated resource catalog.
            Resource.transaction do
                routes_by_engine.each do |engine, controllers|
                    controllers.each do |route, actions|
                        # Build the standard controller name from its route.
                        # Examples:
                        #   users -> Users
                        #   lesli_bell/notifications -> LesliBell::Notifications
                        #   account/currency/exchange_rates -> Account::Currency::ExchangeRates
                        identifier = route.camelize
                        # Create the controller descriptor or update its existing metadata.
                        controller = Resource.find_or_initialize_by(route: route)
                        controller.update!(
                            label: identifier.demodulize.humanize,
                            engine: engine,
                            identifier: identifier
                        )

                        # Register each action only once. Different HTTP verbs can
                        # point to the same controller action.
                        actions.uniq.each do |action|
                            controller.children.find_or_create_by!(
                                action: action,
                                identifier: action,
                                label: action.humanize
                            )
                        end
                    end
                end
            end
        end

        private

        def routes_by_engine
            # Group the available actions by engine and controller.
            # Example: { "lesli_bell" => { "lesli_bell/notifications" => ["index"] } }
            controllers = { "rails_app" => {}, "lesli" => {} }

            # Get controllers and actions from the main Rails application.
            Rails.application.routes.routes.each do |route|
                controller = route.defaults[:controller]
                action = route.defaults[:action]
                next if controller.blank? || action.blank?
                # Exclude internal Rails routes and the default welcome page.
                next if HOST_INTERNAL_CONTROLLERS.any? { |name| controller.include?(name) }

                # Devise routes belong to Lesli's access-control catalog,
                # even though they are mounted in the main application.
                engine = DEVISE_CONTROLLERS.include?(controller) ? "lesli" : "rails_app"
                (controllers[engine][controller] ||= []) << action
            end

            # Get controllers and actions from each installed engine.
            LesliSystem.engines.each do |engine, info|
                # The main application was already processed above.
                next if engine == "Root"

                engine.constantize::Engine.routes.routes.each do |route|
                    controller = route.defaults[:controller]
                    action = route.defaults[:action]
                    # Mounted apps and redirects do not necessarily name an action.
                    next if controller.blank? || action.blank?
                    next if controller.include?("rails/health")

                    # Create the engine/controller containers before adding the action.
                    controllers[info[:code]] ||= {}
                    (controllers[info[:code]][controller] ||= []) << action
                end
            end

            controllers
        end
    end
end
