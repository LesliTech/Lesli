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

require 'bcrypt'

class User::Session < ApplicationLesliRecord
    belongs_to :user, foreign_key: "users_id"
    
    after_create :set_uuid

    def set_uuid

        rebuild_uuid = true

        while rebuild_uuid do

            user_uuid = SecureRandom.uuid
            session_uuid = SecureRandom.uuid

            # assign token to user if token is unique
            if not User::Session.find_by(:user_uuid => user_uuid, :session_uuid => session_uuid)
                self.user_uuid = user_uuid
                self.session_uuid = session_uuid
                self.save!
                rebuild_uuid = false
            end

        end


        return if not self.session_token.blank?

        rebuild_token = true

        while rebuild_token do

            session_token = SecureRandom.alphanumeric(16)

            # assign token to user if token is unique
            if not User::Session.find_by(:session_token => session_token)
                self.session_token = session_token
                self.save!
                rebuild_token = false
            end

        end
        
    end

    def self.index(current_user, query)
        sessions = current_user.sessions
        .where(expiration_at: nil)
        .select(
            :id,
            :user_remote,
            :user_agent,
            :session_source,
            LC::Date2.new.db_column("last_used_at"),
            LC::Date2.new.db_column("created_at"),
            :users_id
        )
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(updated_at: :desc)

        LC::Response.pagination(
            sessions.current_page,
            sessions.total_pages,
            sessions.total_count,
            sessions.length,
            sessions
        )
    end

end
