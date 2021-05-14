class CreateTemplateAudienceDocuments < ActiveRecord::Migration[6.1]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000006_files.json')))
        create_table :template_audience_documents do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end

            t.string :model_type

            t.timestamps
        end
        add_reference :template_audience_documents, :users, foreign_key: true
        add_reference :template_audience_documents, :templates, foreign_key: true
    end
end
