class Bell < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "id"
    has_many :notifications
end
