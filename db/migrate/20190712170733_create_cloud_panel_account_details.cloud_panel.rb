# This migration comes from cloud_panel (originally 20190801000014)
class CreateCloudPanelAccountDetails < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_account_details do |t|

            t.string :company_name
            t.timestamps
            
        end
        add_reference :cloud_panel_account_details, :cloud_panel_accounts, foreign_key: true
    end
end
