class CreateBellMessages < ActiveRecord::Migration[6.0]
    def change
        create_table :bell_messages do |t|
            t.timestamps
        end
        add_reference :bell_messages, :bells, foreign_key: true
    end
end
