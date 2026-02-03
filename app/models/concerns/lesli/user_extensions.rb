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

# User extension methods
# Custom methods that belongs to a instance user
module Lesli
    module UserExtensions
        extend ActiveSupport::Concern

        # Returns the user's full name if available, or their email as a fallback.
        def full_name
            if first_name.present?
                [first_name, last_name.presence].compact.join(" ")
            else
                email
            end
        end

        # Retrieves and returns the name initials of the user 
        # depending on the available information.
        def full_name_initials
            return "" if first_name.blank?

            initials = first_name.strip[0]&.upcase || ""
            initials += last_name.strip[0]&.upcase if last_name.present?
            initials
        end

        # Returns the local configuration for the user,
        # if there is no locale the default local of the platform will be returned
        def locale
            user_locale = self.settings.find_by(name: "locale")

            # return the desire locale by the user
            return user_locale.value.to_sym if user_locale

            # create a desire locale if the record does not exist 
            self.settings.create_with(:value => I18n.locale).find_or_create_by(:name => "locale")

            # reevaluate
            self.locale()
        end

        # Return a string with the names of all the roles assigned to the user
        def role_names 
            self.roles.pluck(:name).join(', ')
        end

        # Register a audit log for the current user
        def log(
            engine:nil, # must be MyEngine
            source:nil, # must be self.class
            action:nil, # must be action_name
            operation:nil,   # two word action description
            description:nil, # human readable description
            session_id:nil,  # must come from server session
            subject:nil # resource related to the log
            )

            return unless defined?(LesliAudit)

            self.logs.create!({
                engine: engine,
                source: source,
                action: action,

                operation: operation,
                description: description,
                session_id: session_id,

                subject_type: subject&.class&.name,
                subject_id: subject&.id,

                account: self&.account&.audit
            })
        end
    end
end
