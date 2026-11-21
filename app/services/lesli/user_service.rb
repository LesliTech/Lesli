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
    class UserService < Lesli::ApplicationLesliService
        def find(id)
            super(current_user.account.users.find_by(id: id))
        end

        # Return only the identifier and display name needed by selectors.
        # This read is account-scoped and intentionally not paginated.
        def list(role: nil)
            users = current_user.account.users.order(:first_name, :last_name, :id)
            if role.present?
                users = if defined?(LesliShield)
                    users.joins(:roles).where(lesli_roles: { name: role.split(",").map(&:strip) }).distinct
                else
                    users.none
                end
            end

            users.select(:id, :first_name, :last_name, :email).map do |user|
                { "id" => user.id, "name" => user.full_name }
            end
        end

        def index
            users = current_user.account.users.order(:first_name, :last_name, :id)
            users = users.select(
                "lesli_users.*",
                "TRIM(CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, ''))) AS fullname",
                "CASE WHEN active THEN 'active' ELSE 'inactive' END AS status",
                "'' AS rolenames",
                Date2.new.date_time.db_column("current_sign_in_at")
            ).page(query.dig(:pagination, :page)).per(query.dig(:pagination, :perPage))

            # Preload role names instead of using database-specific string aggregation.
            if defined?(LesliShield)
                users = users.preload(:roles)
                users.each { |user| user[:rolenames] = user.roles.map(&:name).join(", ") }
            end

            users
        end

        def show
            resource
        end

        def update(attributes)
            attributes = attributes.to_h.symbolize_keys
            attributes[:time_zone] = attributes[:time_zone].presence if attributes.key?(:time_zone)
            resource.assign_attributes(attributes)
            resource.alias = resource.full_name_initials if resource.alias.blank?

            error(resource.errors.full_messages.to_sentence) unless resource.save
            response(resource)
        end
    end
end
