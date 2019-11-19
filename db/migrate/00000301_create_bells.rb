class CreateBells < ActiveRecord::Migration[6.0]
    def change
        create_table :bells do |t|
        end
        add_foreign_key :bells, :accounts, column: :id
    end
end
