class CreateCompanyRoles < ActiveRecord::Migration[6.0]
    def change
        create_table :company_roles do |t|

            t.timestamps
        end
        add_reference :company_roles, :accounts, foreign_key: true
    end
end
