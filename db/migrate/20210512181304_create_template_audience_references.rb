class CreateTemplateAudienceReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :template_audience_references do |t|

      t.timestamps
    end
  end
end
