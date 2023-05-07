class CreateSystemDescriptors < ActiveRecord::Migration[7.0]
    def change
        create_table :system_descriptors do |t|
            t.string :name
            t.string :engine
            t.string :controller 
            t.string :action
            t.string :reference
            t.datetime :deleted_at, index: true
            t.timestamps
        end
    end
end
