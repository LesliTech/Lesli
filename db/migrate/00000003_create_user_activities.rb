class CreateUserActivities < ActiveRecord::Migration[6.0]
    def change
        create_table :user_activities do |t|
            t.string :title
            t.string :description
            t.timestamps
        end
        add_reference :user_activities, :users, foreign_key: true
    end
end
