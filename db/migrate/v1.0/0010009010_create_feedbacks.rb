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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
        add_reference(:feedbacks, :account, foreign_key: { to_table: :accounts })
    end
end
