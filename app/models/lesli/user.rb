=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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
        include UserSecurity
        include UserExtensions
        #include UserActivities

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
        #:omniauthable, omniauth_providers: [:google_oauth2, :facebook]


        # users belongs to an account only... 
        belongs_to :account, optional: true


        # user details are saved on separate table
        has_one :detail, inverse_of: :user, autosave: true, dependent: :destroy
        accepts_nested_attributes_for :detail, update_only: true


        # users data extensions
        has_many :tokens
        has_many :settings
        has_many :sessions
        has_many :activities #, class_name: "Lesli::Item::Activity"

        

        has_many :shortcuts, class_name: "LesliShield::User::Shortcuts"


        # users can have many roles and too many privileges through the roles
        # lesliroles is a shortcut to Lesli::Roles
        has_many :roles 
        has_many :lesliroles, through: :roles, source: :role, class_name: "Lesli::Role"
        has_many :privileges, through: :lesliroles, class_name: "Lesli::Role::Privilege"


        # callbacks
        before_create :before_create_user
        after_create :after_create_user
        #after_update :update_associated_services


        # allow save duplicated users to execute callbacks
        def save(*args)
            super()
            rescue ActiveRecord::RecordNotUnique => error
        end


        # @return [void]
        # @description Before creating a user we make sure there is no capitalized email
        def before_create_user
            self.email = self.email.downcase
        end


        def after_create_user
            self.activities.create(title: "create_user", description:"User created")
            after_confirmation_user
            after_account_assignation
        end


        # Initialize user settings and dependencies needed
        def after_confirmation_user
            return unless self.confirmed?

            self.activities.create(title: "create_user", description:"User confirmed")

            # create an alias based on user name defined in user extensions
            self.set_alias

            # Minimum security settings required
            #self.settings.create_with(:value => false).find_or_create_by(:name => "mfa_enabled")
            #self.settings.create_with(:value => :email).find_or_create_by(:name => "mfa_method")
        end

        def after_account_assignation
            return unless self.account

            #Courier::One::Firebase::User.sync_user(self)
            # Lesli::Courier.new(:lesli_calendar).from(:calendar_service, self).create({
            #     name: "Personal Calendar", 
            #     default: true
            # })
        end


        def update_associated_services
            if saved_change_to_first_name? || saved_change_to_last_name? || saved_change_to_telephone?

                # defined in user extensions
                self.set_alias

                return 
                if defined? CloudOne

                    data = {
                        full_name: self.user.full_name,
                        telephone: self.telephone,
                    }

                    CloudOne::Firebase::User.update_data(self.user, data)

                end
            end
        end
    end
end
