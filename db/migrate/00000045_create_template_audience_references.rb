class CreateTemplateAudienceReferences < ActiveRecord::Migration[6.1]
    def change
        create_table :template_audience_references do |t|

            t.timestamps
        end

        add_reference :template_audience_references, :model, polymorphic: true
        add_reference :template_audience_references, :template_audiences, foreign_key: true
    end
end