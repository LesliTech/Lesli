=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class CreateDescriptors < ActiveRecord::Migration[7.0]
    def change
        # Production instances have previous implementation of this table and is needed to drop it
        # Deprecated tables
        drop_table :role_describers if ActiveRecord::Base.connection.table_exists? 'role_describers'
        drop_table :role_descriptor_activities if ActiveRecord::Base.connection.table_exists? 'role_descriptor_activities'
        drop_table :user_privilege_actions if ActiveRecord::Base.connection.table_exists? 'user_privilege_actions'
        drop_table :user_webpushes if ActiveRecord::Base.connection.table_exists? 'user_webpushes'
        drop_table :user_describers if ActiveRecord::Base.connection.table_exists? 'user_describers'
        drop_table :role_descriptor_assignments if ActiveRecord::Base.connection.table_exists? 'role_descriptor_assignments'
        drop_table :role_descriptor_privilege_actions if ActiveRecord::Base.connection.table_exists? 'role_descriptor_privilege_actions'

        # Refactored tables (these tables will be created in the future migrations)
        drop_table :descriptor_activities if ActiveRecord::Base.connection.table_exists? 'descriptor_activities'
        drop_table :descriptor_privileges if ActiveRecord::Base.connection.table_exists? 'descriptor_privileges'
        drop_table :role_descriptors if ActiveRecord::Base.connection.table_exists? 'role_descriptors'
        drop_table :descriptors if ActiveRecord::Base.connection.table_exists? 'descriptors'

        create_table :descriptors do |t|
            t.string    :name
            t.string    :description
            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference :descriptors, :accounts, foreign_key:true
        add_reference :descriptors, :descriptors, foreign_key:true
    end
end
