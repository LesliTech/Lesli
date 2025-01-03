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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class CreateLesliAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :lesli_accounts do |t|
            # account status
            #   1. -> :registered
            #   2. -> :onboarding
            #   3. -> :active
            #   4. -> :suspended
            t.integer   :status, default: 1, null: false

            t.string   :region, default: "latin_america"

            # unique email to identify the account
            t.string    :email

            # name of the account
            t.string    :name

            # Acts as paranoid
            t.datetime  :deleted_at, index: true
            t.timestamps
        end
        add_index(:lesli_accounts, :email, unique: true)
    end
end
