class User::Detail < ApplicationRecord
    belongs_to :user, foreign_key: 'users_id', optional: true
end
