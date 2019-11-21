class CreateLocks < ActiveRecord::Migration[6.0]
    def change
        create_table :locks do |t|
        end
        add_foreign_key :locks, :accounts, column: :id
    end
end
