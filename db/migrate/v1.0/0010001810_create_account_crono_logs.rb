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

class CreateAccountCronoLogs < ActiveRecord::Migration[7.0]
    def change
        create_table :account_crono_logs do |t|
            t.string        :engine_code
            t.string        :task_name
            t.string        :execution_result, index: true
            t.string        :execution_source
            t.text          :error_message
            
            t.datetime      :deleted_at, index: true
            
            t.timestamps
        end

        add_reference(:account_crono_logs, :account_crono, foreign_key: { to_table: :account_cronos })
    end
end
