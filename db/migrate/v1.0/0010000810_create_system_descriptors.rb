class CreateSystemDescriptors < ActiveRecord::Migration[7.0]
    def change
        create_table :system_descriptors do |t|
            t.string :name
            t.string :category
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :system_descriptors, :system_controllers, foreign_key: true
    end
end
