# This migration comes from cloud_panel (originally 20190801000004)
class CreateCloudPanelCatalogUserRolePrivileges < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_panel_catalog_user_role_privileges do |t|

            t.timestamps
        end
        add_reference :cloud_panel_catalog_user_role_privileges, :cloud_panel_catalog_user_roles, foreign_key: true, index: { name: 'panel_catalog_user_role_privileges-user_roles'}
    end
end
