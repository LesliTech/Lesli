class AlterUserSettings < ActiveRecord::Migration[7.0]
    def change
        add_index :user_settings, [:users_id, :name], unique: true
    end
end
