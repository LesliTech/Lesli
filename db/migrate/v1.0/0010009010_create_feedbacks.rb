=begin

Copyright (c) 2021, all rights reserved.

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

class CreateFeedbacks < ActiveRecord::Migration[6.1]
    def change
        create_table :feedbacks do |t|

            # Contact info
            t.string    :email
            t.string    :telephone
            t.string    :company_name
            t.string    :first_name
            t.string    :last_name

            # Relevant data
            t.text      :message
            t.boolean   :subscribed
            t.string    :category   # contact_us, feedback, report_error, report_abuse, block_object, etc.
            t.string    :status     # created, reviewed, solved, closed
            t.string    :source     # where the issue was reported:  web_page, email, call_center, etc.
            t.string    :reference  # url of the website where the feedback were sent

            t.datetime  :deleted_at, index: true
            t.timestamps
        end
        add_reference :feedbacks, :accounts, foreign_key: true
    end
end
