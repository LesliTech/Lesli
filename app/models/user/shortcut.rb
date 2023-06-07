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
class User::Shortcut < ApplicationLesliRecord
    belongs_to :user, foreign_key: "user_id"
    
    validates :name, presence: true
    validates :url, presence: true
    validates :users_id, presence: true

    def self.index(current_user, query, params)
        user_id = params[:user_id]

        shortcuts = User::Shortcut.joins(:user)
        .select(:id, :name, :icon, :url, :engine_code, LC::Date2.new.date_time.db_timestamps("user_shortcuts"))
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(updated_at: :desc)

        LC::Response.pagination(
            shortcuts.current_page,
            shortcuts.total_pages,
            shortcuts.total_count,
            shortcuts.length,
            shortcuts
        )
    end

    def show(current_user, query)
        self
    end

end
