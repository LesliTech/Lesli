class Account < ApplicationRecord

    belongs_to :account_plan, foreign_key: 'account_plans_id'
    has_many :user, foreign_key: 'users_id'
    has_one :team, class_name: "CloudTeam::Account", foreign_key: "accounts_id"

end
