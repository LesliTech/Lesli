class Account < ApplicationRecord

    #belongs_to :users
    belongs_to :user, foreign_key: 'users_id'
    belongs_to :account_plan, foreign_key: 'account_plans_id'
    has_one :cloudpanel_account_detail

end
