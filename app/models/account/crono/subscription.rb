=begin
Copyright (c) 2022, all rights reserved.

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
class Account::Crono::Subscription < ApplicationLesliRecord
    belongs_to :crono,      foreign_key: "account_cronos_id"
    belongs_to :user,       foreign_key: "users_id"

    after_validation :set_engine_and_task, on: [:create, :update]

    def self.index(current_user, query, crono)
        subscriptions = crono.subscriptions.joins(:user).select(
            :created_at,
            :engine_code,
            :task_name,
            :active,
            :users_id,
            "users.name as user_name"
        )
        
        crono.subscriptions.map do |subscription|
            subscription_attributes = subscription.attributes
            subscription_attributes["created_at_string"] = LC::Date.to_string_datetime(subscription_attributes["created_at"])

            subscription_attributes
        end
    end

    def show(current_user, query)
        self
    end

    protected

    def set_engine_and_task
        # crono should always exist, because this executes after validation
        self.engine_code = crono.engine_code
        self.task_name = crono.task_name
    end
end
