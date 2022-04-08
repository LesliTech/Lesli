=begin
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Account::Crono < ApplicationLesliRecord
    belongs_to :account,    foreign_key: "accounts_id"
    belongs_to :user,       foreign_key: "users_id"

    has_many :logs,         foreign_key: "account_cronos_id"
    has_many :subscriptions,foreign_key: "account_cronos_id"

    # validate require fields
    validates_presence_of :name
    validates_presence_of :task_name
    validates_presence_of :engine_code

    # validate numerical fields
    validates_numericality_of :minute,       only_integer: true
    validates_numericality_of :hour,         only_integer: true
    validates_numericality_of :day_of_month, only_integer: true
    validates_numericality_of :month,        only_integer: true
    validates_numericality_of :day_of_week,  only_integer: true

    enum status: {
        inactive: 0,
        active: 1
    }

    def self.index(current_user, query)
        current_user.account.cronos
    end

    def show(current_user, query)
        self
    end
end
