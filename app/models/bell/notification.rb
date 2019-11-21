class Bell::Notification < ApplicationRecord
    self.table_name = 'bell_notifications'
    belongs_to :user, class_name: 'User', foreign_key: 'users_id'
end
