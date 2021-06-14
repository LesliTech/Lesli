class CreateSystemControllers < ActiveRecord::Migration[6.1]
    def change
        create_table :system_controllers do |t|
            t.string :name
            
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end
    end
end
