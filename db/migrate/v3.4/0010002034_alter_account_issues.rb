=begin
Copyright (c) 2023, all rights reserved.

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
class AlterAccountIssues < ActiveRecord::Migration[7.0]
    def change
        # Add polymorphic reference to the model that is related to the issue (report_error, report_abuse, block_object, etc.)
        add_reference :account_issues, :model, polymorphic: true
    end
end
