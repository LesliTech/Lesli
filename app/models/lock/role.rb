class Lock::Role < ApplicationRecord
    has_many :lock_privileges, class_name: "RolePrivilege", foreign_key: 'lock_roles_id'
    belongs_to :lock, class_name: "Lock", foreign_key: 'locks_id'
end
