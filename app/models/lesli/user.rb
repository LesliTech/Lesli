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
        include LesliShield::UserSecurity if defined?(LesliShield)

        # user required configuration
        validates(:email, 
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true, 
            uniqueness: true
        );

        # devise implementation
        devise( 
            :database_authenticatable,
            :registerable,
            :rememberable,
            :recoverable,
            :validatable,
            :confirmable,
            :trackable
        );

        # users belongs to an account only... 
        belongs_to :account, optional: true


        # user details are saved on separate table
        has_one :detail, inverse_of: :user, autosave: true, dependent: :destroy
        accepts_nested_attributes_for :detail, update_only: true


        # users data extensions
        has_many :tokens
        has_many :settings
        has_many :sessions, class_name: 'LesliShield::User::Session'
        has_many :requests, class_name: 'LesliAudit::UserRequest'
        has_many :journals, class_name: 'LesliAudit::UserJournal'
        has_many :logs, class_name: 'LesliAudit::UserLog'

        
        # users can have many roles and too many privileges through the roles
        # lesliroles is a shortcut to Lesli::Roles
        has_many :roles, class_name: "LesliShield::User::Role"
        has_many :lesliroles, through: :roles, source: :role, class_name: "Lesli::Role"
        has_many :privileges, through: :lesliroles


        # allow save duplicated users to execute callbacks
        def save(*args)
            super()
            rescue ActiveRecord::RecordNotUnique => error
        end


        #
        def log(
            engine:nil, # must be MyEngine
            source:nil, # must be self.class
            action:nil, # must be action_name
            operation:nil,   # two word action description
            description:nil, # human readable description
            session_id:nil,  # must come from server session
            subject:nil # resource related to the log
        )

            return unless defined?(LesliAudit)

            self.logs.create!({
                engine: engine,
                source: source,
                action: action,

                operation: operation,
                description: description,
                session_id: session_id,

                subject_type: subject&.class&.name,
                subject_id: subject&.id,

                account: self&.account&.audit
            })
        end
    end
end
