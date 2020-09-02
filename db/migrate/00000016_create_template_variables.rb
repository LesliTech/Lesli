class CreateTemplateVariables < ActiveRecord::Migration[6.0]
    def change
        create_table :template_variables do |t|
            t.string :name
            t.string :field_name
            t.string :table_name
            t.string :table_alias
            t.string :variable_type
            
            t.datetime :deleted_at, index: true  
            
            t.timestamps
        end

        add_reference :template_variables, :users, foreign_key: true
        add_reference :template_variables, :templates, foreign_key: true    
    end
end