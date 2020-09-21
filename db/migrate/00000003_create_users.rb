=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|

            # Hard-lock strategy
            t.boolean :active, default: true, null: false

            # Database authenticatable
            t.string :email,              null: false, default: ""
            t.string :encrypted_password, null: false, default: ""

            # Recoverable
            t.string    :reset_password_token
            t.datetime  :reset_password_sent_at

            # Rememberable
            t.datetime  :remember_created_at

            # Trackable
            t.integer   :sign_in_count, default: 0, null: false
            t.datetime  :current_sign_in_at
            t.datetime  :last_sign_in_at
            t.inet      :current_sign_in_ip
            t.inet      :last_sign_in_ip

            # Confirmable
            t.string    :confirmation_token
            t.datetime  :confirmed_at
            t.datetime  :confirmation_sent_at
            t.string    :unconfirmed_email # Only if using reconfirmable

            # Lockable
            t.integer   :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
            t.string    :unlock_token # Only if unlock strategy is :email or :both
            t.datetime  :locked_at

            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps null: false

        end

        add_reference :users, :roles, foreign_key: true
        add_reference :users, :accounts, foreign_key: true

        add_index :users, :email,                unique: true
        add_index :users, :reset_password_token, unique: true
        add_index :users, :confirmation_token,   unique: true
        add_index :users, :unlock_token,         unique: true

        # adding account owner (user)
        add_reference :accounts, :users, foreign_key: true
        
    end
end
