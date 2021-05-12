class CreateTemplateAudiences < ActiveRecord::Migration[6.1]
  def change
    create_table :template_audiences do |t|

      t.timestamps
    end
  end
end
