class Lock::RoleOverride < ApplicationRecord
    has_and_belongs_to_many :users, foreign_key: 'id'
end
