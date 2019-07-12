# This migration comes from cloud_panel (originally 20190801000016)
class CreateCloudPanelAccountUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_account_users do |t|

            t.timestamps
        end
        add_reference :cloud_panel_account_users, :cloud_panel_accounts, foreign_key: true
        add_reference :cloud_panel_account_users, :users, foreign_key: true
        add_reference :cloud_panel_account_users, :cloud_panel_catalog_user_roles, foreign_key: true, index: { name: 'panel_account_users-catalog_user_roles'}
    end
end
