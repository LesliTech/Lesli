class Bell < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "id"
    has_many :notifications, class_name: "Bell::Notification", foreign_key: "bells_id"
end
