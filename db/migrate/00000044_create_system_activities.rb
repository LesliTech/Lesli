class CreateSystemActivities < ActiveRecord::Migration[6.0]
    def change
        create_table :system_activities do |t|
            t.string :system_module
            t.string :system_process
            t.json :description
            
            t.timestamps
        end

        add_reference :system_activities, :accounts, foreign_key:true
    end
end
