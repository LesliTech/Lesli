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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class CreateLesliUserRequests < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_user_requests do |t|
            t.string    :request_controller
            t.string    :request_action
            t.string    :request_method
            t.integer   :request_count
            t.timestamps
        end

        add_reference(:lesli_user_requests, :user, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_user_requests, :session, foreign_key: { to_table: :lesli_user_sessions })
        #add_index(:lesli_user_requests, %i[request_controller request_action user_id], unique: true, name: "lesli_user_requests_index")
        add_index(:lesli_user_requests, %i[request_controller request_action user_id session_id], unique: true, name: "lesli_user_requests_index")
    end
end
