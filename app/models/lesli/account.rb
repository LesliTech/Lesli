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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class Account < ApplicationLesliRecord


        # accounts always belongs to a user
        belongs_to :user, optional: true


        # account resources
        has_many :users
        has_many :roles
        has_many :files
        has_many :cronos
        has_many :settings
        has_many :locations
        has_many :feedbacks
        has_many :descriptors
        has_many :activities, class_name: "Account::Activity"
        has_many :currencies, class_name: "Account::Currency"
        has_many :logs



        # account statuses
        enum status: [
            :registered,
            :onboarding,
            :active,
            :suspended
        ]


        # company region (GDPR)
        enum region: {
            latin_america: "latin_america",
            united_states: "united_states",
            european_union: "european_union"
        }


        # required a name for the lesli account
        validates :company_name, :presence => true
    end
end
