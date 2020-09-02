class CreateTemplateDocuments < ActiveRecord::Migration[6.0]
    def change
        create_table :template_documents do |t|
            t.string :name
            t.string :attachment
            t.string :template_type
            t.datetime :deleted_at, index: true  
            
            t.timestamps
        end

        add_reference :template_documents, :users, foreign_key: true
        add_reference :template_documents, :templates, foreign_key: true
    end
end