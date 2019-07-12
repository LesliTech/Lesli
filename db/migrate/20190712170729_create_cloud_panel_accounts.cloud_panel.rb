# This migration comes from cloud_panel (originally 20190801000001)
class CreateCloudPanelAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_accounts do |t|

            t.timestamps
        end
        add_reference :cloud_panel_accounts, :accounts, foreign_key: true
    end
end
