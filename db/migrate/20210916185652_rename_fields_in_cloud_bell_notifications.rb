class RenameFieldsInCloudBellNotifications < ActiveRecord::Migration[6.1]
    def change
        # rename_column :cloud_bell_notifications, :kind, :category
        # rename_column :cloud_bell_notifications, :sender, :channel
    end
end