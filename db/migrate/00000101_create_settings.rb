class CreateSettings < ActiveRecord::Migration[6.0]
    def change
        create_table :settings do |t|
        end
        add_foreign_key :settings, :accounts, column: :id
    end
end
