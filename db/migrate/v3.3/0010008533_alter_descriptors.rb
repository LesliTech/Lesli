# Copyright (c) 2023, all rights reserved.

# All the information provided by this platform is protected by international laws related  to 
# industrial property, intellectual property, copyright and relative international laws. 
# All intellectual or industrial property rights of the code, texts, trade mark, design, 
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // · 


class AlterDescriptors < ActiveRecord::Migration[7.0]
    def change
        add_column  :descriptors,   :description,       :string
        add_column  :descriptors,   :descriptors_id,    :bigint
        add_index   :descriptors,   :descriptors_id

        # We need to migrate all the descriptors names of the table role_descriptors to descriptors

        # It has to be done with empty roles tables, so, would be like a migration from scratch
        # therefore, we're going to truncate the tables
        [
            "descriptor_privileges",
            "role_describers",
            "descriptor_activities",
            "user_describers",
            "descriptors",
            "role_privileges"
        ].each do |table|
            L2.warning "Truncating table '#{table}' ..."
            ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
        end


        # Alright, we need to query to get all the info a role descriptor has access to
        query = Account.first.roles.joins(
            descriptor_assignments: [
                descriptor: [privilege_actions: {system_action: :system_controller}]
            ]
        )

        # Getting the fields needed to copy the roles info
        query = query.select(
            :id, 
            "role_descriptors.name",
            "role_descriptors.description",
            ""
        )

        # Now we start the migration as such
        RoleDescriptor.all.each do |role_descriptor|
            Descriptor.create!(
                name: role_descriptor.name, 
                description: role_descriptor.description,
                descriptors_id: role_descriptor.role_descriptors_id,
                account: Account.first,
            )
        end
    end
end
