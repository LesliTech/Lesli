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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Role::Descriptor < ApplicationLesliRecord
    belongs_to :role
    belongs_to :descriptor

    after_save :synchronize_privileges
    after_destroy :synchronize_privileges

    def self.index current_user, query, role

        d = role.descriptors.joins(privileges: :system_controller_action)

        L2.info "start"
        pp d
        L2.info "end"

        return d

=begin
        # get the active descriptors assigned to the role
        Role::Descriptor
        .joins(:system_controller)
        .joins(%(
            LEFT OUTER JOIN "role_descriptors" 
            ON "role_descriptors"."deleted_at" IS NULL 
            AND "role_descriptors"."descriptor_id" = "descriptors"."id"
            AND "role_descriptors"."roles_id" = #{role.id}
        ))
        .select(
            "coalesce(role_descriptors.descriptor_id, descriptors.id) as id", 
            "descriptors.name as name", 
            "system_controllers.reference as reference", 
            "system_controllers.route as controller", 
            "descriptors.category as action", 
            "system_controllers.engine as engine", 
            "case when role_descriptors.descriptor_id is null then false else true end as active"
        )
=end
    end

    def synchronize_privileges
        #PrivilegeServices.new(self.role.id).synchronize
    end
end
