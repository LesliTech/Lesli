class ModifyUserActivities < ActiveRecord::Migration[6.0]
    def change
        add_column :user_activities, :request_action, :string
    end
end


