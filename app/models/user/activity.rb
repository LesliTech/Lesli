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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class User::Activity < CloudObject::Activity
    belongs_to :user
    belongs_to :assigned, class_name: "User"

    enum category: {
        action_create:                          "action_create",
        action_show:                            "action_show",
        action_update:                          "action_update",
        action_destroy:                         "action_destroy",
        action_create_user_role:                "action_create_user_role",
        action_destroy_user_role:               "action_destroy_user_role",
        action_become:                          "action_become",
        action_create_notification:             "action_create_notification"
    }
end
