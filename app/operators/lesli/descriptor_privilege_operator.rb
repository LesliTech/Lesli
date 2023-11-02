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
    class DescriptorPrivilegeOperator < Lesli::ApplicationLesliService

        @descriptor = nil

        def initialize descriptor
            @descriptor = descriptor
        end

        def add_profile_privileges(descriptor)

            # Adding default system actions for profile descriptor
            [
                { controller: "lesli_admin/profiles", actions: ["show"] },      # enable profile view
                { controller: "lesli/users", actions: ["options", "update"] },  # enable user edition
                { controller: "lesli/abouts", actions: ["show"] },              # system status
                { controller: "lesli/user/sessions", actions: ["index"] }       # session management
            ].each do |controller_action|

                controller_action[:actions].each do |action_name|

                    system_controller_action = SystemController::Action.joins(:system_controller)
                    .where("lesli_system_controllers.route = ?", controller_action[:controller])
                    .where("lesli_system_controller_actions.name = ?", action_name)

                    descriptor.privileges.find_or_create_by(
                        action: system_controller_action.first
                    )
                end
            end
        end

        def add_owner_privileges(descriptor)

            # Adding default system actions for profile descriptor
            actions = SystemController::Action.all

            actions.each do |action|
                descriptor.privileges.find_or_create_by(action: action)
            end
        end
    end
end
