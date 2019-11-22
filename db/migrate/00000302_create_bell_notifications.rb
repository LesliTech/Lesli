class CreateBellNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :bell_notifications do |t|
            t.string :subject
            t.text   :body
            t.string :href
            t.string :format
            t.boolean :read, default: false
            t.timestamps
        end
        add_reference :bell_notifications, :bells, foreign_key: true
        add_reference :bell_notifications, :users, foreign_key: true
    end
end
