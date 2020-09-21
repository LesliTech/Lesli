class CreateAccountActivities < ActiveRecord::Migration[6.0]
    def change
        create_table :account_activities do |t|
            t.string :system_module
            t.string :system_process
            t.string :description
            t.json   :payload
            t.timestamps
        end
        add_reference :account_activities, :accounts, foreign_key:true
    end
end
