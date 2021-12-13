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
    belongs_to :account, foreign_key: "accounts_id"
    belongs_to :user, foreign_key: "users_id"

    # validate require fields
    validates_presence_of :name

    # validate numerical fields
    validates_numericality_of :minute,       only_integer: true
    validates_numericality_of :hour,         only_integer: true
    validates_numericality_of :day_of_month, only_integer: true
    validates_numericality_of :month,        only_integer: true
    validates_numericality_of :day_of_week,  only_integer: true

    def self.index(current_user, query)
        current_user.account.cronos
    end

    def show(current_user, query)
        self
    end
end