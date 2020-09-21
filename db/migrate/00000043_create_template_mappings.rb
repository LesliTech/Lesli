class CreateTemplateMappings < ActiveRecord::Migration[6.0]
    def change
            create_table :template_mappings do |t|
            t.datetime :deleted_at, index: true  
            
            t.timestamps
        end

        add_reference :template_mappings, :template_documents, foreign_key: true
        add_reference :template_mappings, :template_variables, foreign_key: true
    end
end