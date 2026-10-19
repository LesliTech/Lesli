=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class User < ApplicationLesliRecord
        include Lesli::UserExtensions

        # user required configuration
        validates(:email, 
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true, 
            uniqueness: true
        );

        # users belongs to an account only... 
        belongs_to :account, optional: true


        # user details are saved on separate table
        has_one :detail, inverse_of: :user, autosave: true, dependent: :destroy
        accepts_nested_attributes_for :detail, update_only: true


        # users data extensions
        has_many :tokens
        has_many :settings

        # Authentication and authorization records are implemented by
        # LesliShield. These associations remain explicit here because they
        # are part of the public API used throughout the platform.
        has_many :sessions, class_name: "LesliShield::User::Session"
        has_many :user_roles, class_name: "LesliShield::User::Role"
        has_many :roles,       through: :user_roles, source: :role
        has_many :privileges,  through: :roles

        # Audit records are implemented by LesliAudit. The associations are
        # declared here because requests, journals, and logs form part of the
        # user API consumed by the platform.
        has_many :requests, class_name: "LesliAudit::UserRequest", foreign_key: :user_id, inverse_of: :user
        has_many :journals, class_name: "LesliAudit::UserJournal", foreign_key: :user_id, inverse_of: :user
        has_many :logs, class_name: "LesliAudit::UserLog", foreign_key: :user_id, inverse_of: :user
        has_many :account_logs, class_name: "LesliAudit::AccountLog", foreign_key: :user_id, inverse_of: :user

        # allow save duplicated users to execute callbacks
        def save(*args)
            super()
            rescue ActiveRecord::RecordNotUnique => error
        end

        before_create :before_create_user

        private

        def before_create_user
            self.uid ||= loop do
                candidate = generate_resource_uid(prefix:'LID')
                break candidate unless self.account&.users&.exists?(uid: candidate)
            end
        end

        def generate_resource_uid(prefix:'Lesli')
            charset = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"
            letters = Array.new(4) { charset.chars.sample }.join
            return "#{prefix}-#{letters}"
        end
    end
end
