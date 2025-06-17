
module MigrationHelpers
    module Shared
        module CatalogStructure
            def create_table_lesli_shared_catalogs_10(engine)

                table_name, table_name_account = table_name_for_shared(engine, :catalogs)

                create_table table_name do |t|
                    t.string    :name 
                    t.integer   :order
                    t.boolean   :default, default: false
                    t.timestamps 
                end
                add_reference(table_name, :parent, null: true, foreign_key: { to_table: table_name }, index: true)
                add_reference(table_name, :account, null: false, foreign_key: { to_table: table_name_account }, index: true)
            end
        end
    end
end
