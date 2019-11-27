class Lock < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: 'id'
    has_many :lock_roles, class_name: "Role", foreign_key: 'locks_id'
end

