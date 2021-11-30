=begin

Copyright (c) 2020, all rights reserved.

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

class Account::Integration < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"
    belongs_to :user_main, foreign_key: "user_main_id", class_name: "User"
    belongs_to :user, foreign_key: "users_id"

    validates :name, presence: true

    def self.index current_user
        current_user.account.integrations
        .joins("inner join users u on u.id = account_integrations.users_id")
        .joins("inner join (
                    select max(id) id, users_id 
                    from user_sessions
                    group by users_id
                ) as last_session
                on last_session.users_id = account_integrations.users_id")
        .joins("inner join user_sessions us on us.id = last_session.id")
        .order(:id)
        .select(
            :id,
            :name,
            :active,
            :email,
            :usage_count,
            :last_used_at,
            :expiration_at
        )
    end

    def self.show current_user, params

        # get integration
        integration = current_user.account.integrations.find(params[:id])

        # get last active session for integration
        session = integration.user.sessions.last

        {
            id: integration[:id],
            name: integration[:name],
            user_main: integration.user_main,
            session: (session.usage_count ? {} : session)
        }
        
    end

end
