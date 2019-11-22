class Bell::Notification < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'users_id'
    belongs_to :bell, class_name: 'Bell', foreign_key: 'bells_id'
end
