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
    class AccountOperator
        def initialize(account:)
            @account = account
        end

        def initialize_roles!
            Account.transaction do
                owner = account.roles.create_with(permission_level: 2147483647, active: true)
                    .find_or_create_by!(name: "owner")
                admin = account.roles.create_with(permission_level: 100000, active: true)
                    .find_or_create_by!(name: "admin")
                guest = account.roles.create_with(
                    permission_level: 10, active: true, path_default: "/administration/profile"
                ).find_or_create_by!(name: "guest")

                if defined?(LesliShield)
                    actions = LesliShield::RoleActionService.new(nil)
                    actions.add_owner_actions(owner)
                    actions.add_owner_actions(admin)
                    actions.add_guest_actions(guest)
                end
            end

            account
        end

        def initialize_engines!
            Account.transaction do
                initialized_engines = []
                LesliSystem.engines.each_key do |engine|
                    next if %w[Lesli LesliBabel Root].include?(engine)

                    engine_account = engine.constantize::Account.find_or_create_by!(account: account)
                    initialized_engines << engine if engine_account.previously_new_record?
                end

                # Audit must exist before recording initialization, regardless
                # of registry order. Repeated runs do not repeat these events.
                initialized_engines.each do |engine|
                    account.log(:account_initialization, "Engine: #{engine} initialized successfully")
                end
            end

            account
        end

        private

        attr_reader :account
    end
end
