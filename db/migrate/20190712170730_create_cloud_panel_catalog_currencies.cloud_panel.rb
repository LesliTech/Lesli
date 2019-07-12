# This migration comes from cloud_panel (originally 20190801000002)
class CreateCloudPanelCatalogCurrencies < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_catalog_currencies do |t|

            t.timestamps
        end
        add_reference :cloud_panel_catalog_currencies, :cloud_panel_accounts, foreign_key: true
    end
end
