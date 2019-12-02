class User::Detail < ApplicationRecord
    self.table_name = 'user_details'
    belongs_to :user, foreign_key: 'users_id', optional: true
end
