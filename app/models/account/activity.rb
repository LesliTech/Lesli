class Account::Activity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"
end
