class CreateSettings < ActiveRecord::Migration[6.0]
    def change
        create_table :settings do |t|
            t.string :name
            t.string :value
            t.timestamps
        end
        add_reference :settings, :accounts, foreign_key: true
    end
end
