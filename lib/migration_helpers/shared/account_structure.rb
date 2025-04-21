
module MigrationHelpers
    module Shared
        module AccountStructure
            def create_table_lesli_shared_account_10(engine)

                table_name, table_name_account = table_name_for_shared(engine, :accounts)

                create_table table_name do |t|
                    t.string   :name 
                    t.integer  :status, null: false, default: 0
                    t.datetime :enabled_at
                    t.datetime :deleted_at, index: true
                    t.timestamps 
                end
    
                add_reference(table_name, :account, null: false, foreign_key: { to_table: :lesli_accounts }, index: true)
            end
        end
    end
end
