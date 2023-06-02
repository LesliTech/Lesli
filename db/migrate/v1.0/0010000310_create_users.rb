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

class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|

            # Hard-lock strategy
            t.boolean   :active, default: true, null: false

            # authenticatable
            t.string    :email,              null: false, default: ""
            t.string    :encrypted_password, null: false, default: ""

            # Customizable
            t.string    :alias
            t.string    :salutation
            t.string    :first_name
            t.string    :last_name

            # Recoverable
            t.string    :reset_password_token
            t.datetime  :reset_password_sent_at

            # Password and access management
            t.datetime  :password_expiration_at
            t.datetime  :locked_until

            # Rememberable
            t.datetime  :remember_created_at

            # Trackable
            t.integer   :sign_in_count, default: 0, null: false
            t.datetime  :current_sign_in_at
            t.datetime  :last_sign_in_at
            t.inet      :current_sign_in_ip
            t.inet      :last_sign_in_ip

            # Confirmable
            t.string    :unconfirmed_email # Only if using reconfirmable
            t.string    :confirmation_token
            t.datetime  :confirmation_sent_at
            t.datetime  :confirmed_at

            # Telephone confirmation (custom)
            t.string    :telephone
            t.string    :telephone_confirmation_token
            t.datetime  :telephone_confirmation_sent_at
            t.datetime  :telephone_confirmed_at

            # Lockable
            t.integer   :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
            t.string    :unlock_token # Only if unlock strategy is :email or :both
            t.datetime  :locked_at

            # Acts as paranoid
            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference(:users, :account, foreign_key: { to_table: :accounts })
        add_reference(:accounts, :user, foreign_key: { to_table: :users })

        add_index(:users, :email,                unique: true)
        add_index(:users, :unlock_token,         unique: true)
        add_index(:users, :confirmation_token,   unique: true)
        add_index(:users, :reset_password_token, unique: true)
    end
end
