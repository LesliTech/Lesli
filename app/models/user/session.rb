=begin

Copyright (c) 2023, all rights reserved.

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

    after_create :set_session_token

    enum session_sources: {
        dispatcher_standar_session: "dispatcher_standar_session",
        devise_standar_session: "devise_standar_session",
        cloud_shared_public: "cloud_shared_public",
    }

    def set_session_token

        return if self.session_source == "devise_standar_session"

        rebuild_uuid = true

        while rebuild_uuid do

            user_uuid = SecureRandom.uuid
            session_uuid = SecureRandom.uuid

            # assign token to user if token is unique
            unless User::Session.find_by(:user_uuid => user_uuid, :session_uuid => session_uuid)
                self.user_uuid = user_uuid
                self.session_uuid = session_uuid
                self.save!
                rebuild_uuid = false
            end

        end


        return unless self.session_token.blank?


        rebuild_token = true

        while rebuild_token do

            session_token = SecureRandom.alphanumeric(20)

            # assign token to user if token is unique
            unless User::Session.find_by(:session_token => session_token)
                self.session_token = session_token
                self.save!
                rebuild_token = false
            end

        end

    end

    def self.index(current_user, query, params, current_session_id)
        user_id = params[:user_id]

        User::Session.all
        .joins(:user)
        .where(users_id: user_id)
        .where("users.accounts_id = ?", current_user.account.id)
        .where("expiration_at > ? or expiration_at is ?", Time.now.utc, nil)
        .select(
            :id,
            :user_agent,
            :session_source,
            Date2.new.date_time.db_timestamps("user_sessions"),
            Date2.new.date_time.db_column("expiration_at"),
            Date2.new.date_time.db_column("last_used_at"),
            "case when #{current_session_id} = user_sessions.id then true else false end as current_session"
        )
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(updated_at: :desc)

    end

    def active?
        if self.deleted_at.present?
            return false
        end

        if self.expiration_at != nil and self.expiration_at < Time.now.utc
            return false
        end

        return true
    end

end
