class Lock::RolePrivilege < ApplicationRecord
    belongs_to :lock_role, class_name: "Role", foreign_key: 'lock_roles_id'
end
