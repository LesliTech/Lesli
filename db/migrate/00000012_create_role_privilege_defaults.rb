class CreateRolePrivilegeDefaults < ActiveRecord::Migration[6.0]
    def change
        create_table :role_privilege_defaults do |t|
            t.string  :grant_object

            t.boolean :grant_index,     default: false

            t.boolean :grant_edit,      default: false
            t.boolean :grant_show,      default: false
            t.boolean :grant_new,       default: false

            t.boolean :grant_create,    default: false
            t.boolean :grant_update,    default: false
            t.boolean :grant_destroy,   default: false

            t.boolean :grant_search,    default: false

            t.boolean :grant_resources, default: false
            t.boolean :grant_options,   default: false

            t.datetime :deleted_at, index: true
            t.timestamps
            t.timestamps
        end
        add_reference :role_privilege_defaults, :roles, foreign_key: true
    end
end
