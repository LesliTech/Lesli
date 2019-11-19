class CreateBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :bell_notifications do |t|
            t.timestamps
        end
        add_reference :bell_notifications, :bells, foreign_key: true
    end
end
