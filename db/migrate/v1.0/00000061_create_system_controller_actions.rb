class CreateSystemControllerActions < ActiveRecord::Migration[6.1]
    def change
        create_table :system_controller_actions do |t|
            t.string :name 
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end
        
        add_reference :system_controller_actions, :system_controllers, foreign_key: true
    end
end