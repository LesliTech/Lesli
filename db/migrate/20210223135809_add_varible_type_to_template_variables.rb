class AddVaribleTypeToTemplateVariables < ActiveRecord::Migration[6.1]
    def change
        add_column :template_variables, :variable_type, :string
    end
end
