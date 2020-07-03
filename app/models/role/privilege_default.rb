class Role::PrivilegeDefault < ApplicationRecord
    belongs_to :role, foreign_key: "roles_id"
end
