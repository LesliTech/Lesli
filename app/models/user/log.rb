class User::Log < ApplicationRecord
    belongs_to :user, foreign_key: "users_id", inverse_of: :logs
end
