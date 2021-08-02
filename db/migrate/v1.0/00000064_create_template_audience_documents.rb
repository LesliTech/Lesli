class CreateTemplateAudienceDocuments < ActiveRecord::Migration[6.1]
    def change
        create_table :template_audience_documents do |t|
            t.string :name
            t.string :model_type
            t.text   :description

            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference :template_audience_documents, :users, foreign_key: true
        add_reference :template_audience_documents, :templates, foreign_key: true
        add_reference :template_audience_documents, :account_files, foreign_key: true
    end
end