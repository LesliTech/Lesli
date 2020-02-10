
class Setting < ApplicationRecord
    belongs_to :account, foreign_key: 'accounts_id'

    def get(name)
        "ldonis"
    end

end
