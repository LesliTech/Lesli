class Account < ApplicationRecord

    belongs_to :account_plan, foreign_key: 'account_plans_id'
    has_many :user, foreign_key: 'users_id'

    has_one :driver, class_name: "CloudDriver::Account", foreign_key: "id"
    has_one :team, class_name: "CloudTeam::Account", foreign_key: "id"
    has_one :kb, class_name: "CloudKb::Account", foreign_key: "id"

end
