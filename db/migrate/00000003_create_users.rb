=begin

Copyright (c) 2020, all rights reserved.

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

class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|

            # Hard-lock strategy
            t.boolean :active, default: true, null: false

            # Multi-authorization strategy: user|integration
            t.string :category, default: "user", null: false

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

            # Acts as paranoid
            t.datetime :deleted_at, index: true

            # Password management
            t.datetime :password_expiration_at

            t.timestamps null: false

        end

        add_reference :users, :accounts, foreign_key: true

        add_index :users, :email,                unique: true
        add_index :users, :reset_password_token, unique: true
        add_index :users, :confirmation_token,   unique: true
        add_index :users, :unlock_token,         unique: true

        # adding account owner (user)
        add_reference :accounts, :users, foreign_key: true
        
    end
end
