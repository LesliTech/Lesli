class AlterAnnouncementsTable < ActiveRecord::Migration[6.1]
    def change
        # this migration will be deleted
        # add_column      :cloud_bell_announcements, :base_path, :string
        # add_column      :cloud_bell_announcements, :start_at,  :datetime
        
        # rename_column   :cloud_bell_announcements, :kind, :category
        # rename_column   :cloud_bell_announcements, :expiration_at, :end_at
        
        # change_column :cloud_bell_announcements, :status, 'boolean USING CAST(status AS boolean)'
    end
end
