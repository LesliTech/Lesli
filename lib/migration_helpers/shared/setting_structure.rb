
module MigrationHelpers
    module Shared
        module SettingStructure
            def create_table_lesli_shared_settings_10(engine)

                table_name, table_name_account = table_name_for_shared(engine, :settings)

                create_table table_name do |t|
                    t.string :name
                    t.string :value
                    t.timestamps
                end
    
                add_reference(table_name, :user, foreign_key: { to_table: :lesli_users }, index: true)
                add_reference(table_name, :account, null: false, foreign_key: { to_table: table_name_account }, index: true)
            end
        end
    end
end
