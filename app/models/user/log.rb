class User::Log < ApplicationRecord
    belongs_to :user, foreign_key: "users_id", inverse_of: :logs
    belongs_to :user_session, foreign_key: "user_sessions_id", optional: true
end
