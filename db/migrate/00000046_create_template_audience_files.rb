class CreateTemplateAudienceFiles < ActiveRecord::Migration[6.1]
    def change
        # create_table :template_audience_files do |t|
        #     t.string   :name
        #     t.string   :attachment
        #     t.datetime :deleted_at, index: true
        #     t.timestamps
        # end

        # add_reference :template_audience_files, :users, foreign_key: true
        # add_reference :template_audience_files, :template_audiences, foreign_key: true
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000006_files.json')))
        create_table :template_audience_files do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :template_audience_files, :users, foreign_key: true
        add_reference :template_audience_files, :template_audiences, foreign_key: true
    end
end