class CreateCompanyRolePrivileges < ActiveRecord::Migration[6.0]
    def change
        create_table :company_role_privileges do |t|

=begin
entity
get
post
put
delete
=end

        t.timestamps
        end
        add_reference :company_role_privileges, :company_roles, foreign_key: true
    end
end
