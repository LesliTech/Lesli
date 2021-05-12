class CreateTemplateAudiences < ActiveRecord::Migration[6.1]
    def change
        create_table :template_audiences do |t|
            t.string :name
            t.string :description

            t.datetime :deleted_at, index: true
            t.timestamps
        end

        add_reference :template_audiences, :users, foreign_key: true
        add_reference :template_audiences, :templates, foreign_key: true
    end
end
