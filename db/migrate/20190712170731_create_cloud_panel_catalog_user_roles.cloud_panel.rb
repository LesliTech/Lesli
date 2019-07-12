# This migration comes from cloud_panel (originally 20190801000003)
class CreateCloudPanelCatalogUserRoles < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_catalog_user_roles do |t|

            t.timestamps
        end
        add_reference :cloud_panel_catalog_user_roles, :cloud_panel_accounts, foreign_key: true
    end
end
