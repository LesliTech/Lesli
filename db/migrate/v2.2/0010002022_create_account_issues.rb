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
class CreateAccountIssues < ActiveRecord::Migration[7.0]
    def change
        create_table :account_issues do |t|
            # Contact info
            t.string    :first_name
            t.string    :last_name
            t.string    :company_name
            t.string    :email
            t.string    :telephone

            # Relevant data
            t.string    :message
            t.boolean   :subscribed
            t.string    :category   # contact_us, feedback, error_report
            t.string    :status     # created, reviewed, solved, closed
            t.string    :source     # where the issue was reported:  web_page, email, call_center, etc.
            t.string    :reference  # reference to a specific group of reporters

            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference :account_issues, :users,    foreign_key: true
        add_reference :account_issues, :accounts, foreign_key: true
    end
end
