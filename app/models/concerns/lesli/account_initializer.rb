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

module Lesli
    module AccountInitializer
        extend ActiveSupport::Concern

        # initialize minimum resources needed for the account
        def initialize_account


            # create default roles for the new account
            owner = self.roles
            .create_with({ permission_level: 2147483647 })
            .find_or_create_by(:name => "owner")


            # platform administrator role
            admin = self.roles
            .create_with({ permission_level: 100000})
            .find_or_create_by(name: "admin")


            # access only to user profile
            limited = self.roles
            .create_with({ permission_level: 10, path_default: "/administration/profile" })
            .find_or_create_by(name: "limited")


            # Add base privileges to roles
            Lesli::RoleOperator.new(owner).add_owner_actions
            Lesli::RoleOperator.new(admin).add_owner_actions
            Lesli::RoleOperator.new(limited).add_profile_actions

        end


        # initialize engines for new accounts
        def initialize_engines

            LesliSystem.engines.each do |engine, data|

                next if ["Lesli", "LesliBabel", "Root"].include?(engine)

                # Create an associated account if the attribute is blank
                engine.constantize::Account.create!(account: self)
            end
        end      
    end
end
