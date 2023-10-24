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


        # Return a list of users that belongs to the account of the current_user
        # this list is meant to be used in selectors, autocomplets, etc
        def list params=nil
            users = current_user.account.users

            if params[:role].present?
                # add simple quotes to the roles so the sql can manage the query
                roles = params[:role].split(",").map { |role| "'#{role}'" }.join(", ")
                users = users.joins("
                    inner join (
                        select
                            ur.users_id, string_agg(r.\"name\", ', ') role_names
                        from user_roles ur
                        join roles r
                            on r.id = ur.role_id 
                            and r.name in ( #{ roles } )
                        where ur.deleted_at is null
                        group by ur.users_id
                    ) roles on roles.users_id = users.id
                ")
            end

            users.order(name: :asc).select(
                :id,
                :email,
                "CONCAT_WS(' ', first_name, last_name) as name",
                "COALESCE(alias, email) as alias"
            ).as_json
        end
    end
end
