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
    class Role < ApplicationLesliRecord
        belongs_to :account


        # Role resources
        has_many :activities
        has_many :powers, dependent: :delete_all
        has_many :privileges,  dependent: :delete_all
        

        # initializers for new roles
        after_create :after_create_role


        # validations
        validates :name, presence: :true
        validates :object_level_permission, presence: :true


        def after_create_role

            # generate a unique code for the role
            role_code = name
                .downcase                           # string to lowercase
                .gsub(/[^0-9A-Za-z\s\-\_]/, '')     # remove special characters from string
                .gsub(/-/, '_')                     # replace dashes with underscore
                .gsub(/\s+/, '_')                   # replace spaces or spaces with single dash

            # transform UTF-8 characters to ASCI (ex: name in german)
            role_code = I18n.transliterate(role_code) + id.to_s 

            self.update_attribute("code", role_code)
        end


        # @return [Boolean]
        # @description Returns if a role is assigned to users.
        def has_users?
            User::Role.where(role: self).count > 0
        end

        # @return [void]
        # @param current_user [::User] The user that deleted the role
        # @param [Role] The role that was deleted
        # @description Creates an activity for this role indicating that someone deleted it
        # Example
        #   role = Role.find(1)
        #   Role.log_activity_destroy(User.find(1), role)
        def self.log_activity_destroy(current_user, role)
            role.activities.create(
                user_creator: current_user,
                category: "action_destroy"
            )
        end
    end
end
