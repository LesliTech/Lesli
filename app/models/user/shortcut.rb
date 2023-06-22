=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class User::Shortcut < ApplicationLesliRecord
    belongs_to :user, foreign_key: "users_id"
    
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
