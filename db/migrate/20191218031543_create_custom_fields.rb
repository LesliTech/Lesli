class CreateCustomFields < ActiveRecord::Migration[6.0]
    def change
        create_table :custom_fields do |t|
            t.string    :module_name
            t.string    :model_name
            t.string    :field_label
            t.string    :field_name
            t.string    :field_type
            t.string    :field_instructions
            t.boolean   :field_is_required
            t.string    :default_value
            t.json      :allowed_values
            t.string    :placeholder_text
            t.string    :formatting
            t.integer   :character_limit
            t.timestamps
        end
        add_reference :custom_fields, :users, foreign_key: true
    end
end
