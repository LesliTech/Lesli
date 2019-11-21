class CreateBellEmails < ActiveRecord::Migration[6.0]
    def change
        create_table :bell_emails do |t|
            t.timestamps
        end
        add_reference :bell_emails, :bells, foreign_key: true
    end
end
