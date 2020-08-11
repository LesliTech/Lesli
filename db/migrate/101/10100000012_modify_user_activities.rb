class ModifyUserActivities < ActiveRecord::Migration[6.0]
    def change
        add_column :user_activities, :request_controller, :string
        #add_column :user_activities, :request_action, :string
        remove_column :user_activities, :log_scope
    end
end


