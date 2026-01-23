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
    class Account < ApplicationLesliRecord
        include AccountInitializer
        include AccountLogs

        # accounts always belongs to a user
        belongs_to :user, optional: true


        # account resources
        has_many :users
        has_many :roles
        has_many :settings
        has_many :locations
        has_many :currencies
        has_many :requests, class_name: "LesliAudit::AccountRequest"
        has_many :logs, class_name: "LesliAudit::AccountLog"


        # third-party engines associations
        has_one :bell, class_name: "LesliBell::Account"
        has_one :help, class_name: "LesliHelp::Account"
        has_one :audit, class_name: "LesliAudit::Account"
        has_one :admin, class_name: "LesliAdmin::Account"
        has_one :guard, class_name: "LesliGuard::Account"
        has_one :shield, class_name: "LesliShield::Account"
        has_one :letter, class_name: "LesliLetter::Account"
        has_one :papers, class_name: "LesliPapers::Account"
        has_one :support, class_name: "LesliSupport::Account"
        has_one :calendar, class_name: "LesliCalendar::Account"
        has_one :dashboard, class_name: "LesliDashboard::Account"
        


        # account statuses
        enum :status, {
            :active => 'active',
            :suspended => 'suspended',
            :registered => 'registered',
            :onboarding => 'onboarding'
        }


        # company region (GDPR)
        enum :region, {
            america: "america"
        }


        # required a name for the lesli account
        validates :name, :presence => true


        # initializers for new accounts
        after_create :initialize_account
        after_create :initialize_engines

    end
end
