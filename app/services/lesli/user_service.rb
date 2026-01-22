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

        def find id
            super(current_user.account.users.find_by(id: id))
        end


        # Return a list of users that belongs to the account of the current_user
        # this list is meant to be used in selectors, autocomplets, etc
        def list params=nil
            users = current_user.account.users

            if params[:role].present?
                # add simple quotes to the roles so the sql can manage the query
                roles = params[:role].split(",").map { |role| "'#{role}'" }.join(", ")
                # users = users.joins("
                #     inner join (
                #         select
                #             ur.users_id, string_agg(r.\"name\", ', ') role_names
                #         from user_roles ur
                #         join roles r
                #             on r.id = ur.role_id 
                #             and r.name in ( #{ roles } )
                #         where ur.deleted_at is null
                #         group by ur.users_id
                #     ) roles on roles.users_id = users.id
                # ")

                users = users.joins("
                    inner join (
                        select
                            ur.users_id, string_agg(r.\"name\", ', ') role_names
                        from user_roles ur
                        join roles r
                            on r.id = ur.role_id 
                            and r.name in (:roles)
                        where ur.deleted_at is null
                        group by ur.users_id
                    ) roles on roles.users_id = users.id
                ")
                .where('r.name IN (:roles)', roles: roles)

            end

            users.order(name: :asc).select(
                :id,
                :email,
                "CONCAT_WS(' ', first_name, last_name) as name",
                "COALESCE(NULLIF(alias,''), email) as alias"
            ).as_json
        end

        # @return [Array] Paginated index of users.
        # @description Return a paginated array of users, used mostly in frontend views
        # TODO: Implement pg_search
        def index params

            # Build user full name
            fullname_sql = "TRIM(CONCAT(lesli_users.first_name, ' ', lesli_users.last_name))"

            # Build user status
            status_sql = "case when lesli_users.active is true then 'active' else 'inactive' end"

            # Get all the roles assigned to the user
            roles_subquery = <<-SQL
                LEFT JOIN (
                    SELECT ur.user_id, string_agg(r.name, ', ' ORDER BY r.name) as rolenames
                    FROM lesli_user_roles ur
                    JOIN lesli_roles r ON r.id = ur.role_id
                    WHERE ur.deleted_at IS NULL
                    GROUP BY ur.user_id
                ) roles ON roles.user_id = lesli_users.id
            SQL

            current_user.account.users
            .joins(roles_subquery)
            .select(
                :id,
                :email,
                :active,
                "#{status_sql} AS status",
                "#{fullname_sql} AS fullname",
                "COALESCE(roles.rolenames, '') AS rolenames",
                Date2.new.date_time.db_column("current_sign_in_at")
            )
            .page(query.dig(:pagination, :page))
            .per(query.dig(:pagination, :perPage))
        end

        # Creates a query that selects all user information from several tables if CloudLock is present
        def show
            resource
        end

        def update params

            # old_attributes = resource.detail.attributes.merge({
            #     active: resource.active
            # })

            if resource.update(params)
                # new_attributes = resource.detail.attributes.merge({
                #     active: resource.active
                # })
                #resource.log_activity_update(current_user, resource, old_attributes, new_attributes)
            else
                self.error(resource.errors.full_messages.to_sentence)
            end
            
            self
        end
    end
end
