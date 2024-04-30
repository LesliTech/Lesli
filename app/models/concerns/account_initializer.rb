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
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module AccountInitializer
    extend ActiveSupport::Concern


    # initialize minimum resources needed for the account
    def initialize_account

        return unless defined?(LesliSecurity)

        # create initial descriptors
        descriptor_owner = self.descriptors.find_or_create_by(name: "owner")
        descriptor_admin = self.descriptors.find_or_create_by(name: "admin")
        descriptor_profile = self.descriptors.find_or_create_by(name: "profile")

        # create default roles for the new account
        owner = self.roles.create_with({
            active: true, 
            object_level_permission: 2147483647
        }).find_or_create_by(:name => "owner")

        # platform administrator role
        admin = self.roles.create_with({
            active: true, object_level_permission: 100000
        }).find_or_create_by({ name: "admin" })

        # access only to user profile
        limited = self.roles.create_with({
            active: true, object_level_permission: 10, path_default: "/administration/profile" 
        }).find_or_create_by({ name: "limited" })

        # assign descriptors with appropriate privileges
        owner.powers.create_with({
            plist: true, pindex: true, pshow: true, pcreate: true, pupdate: true, pdestroy: true
        }).find_or_create_by(:descriptor => descriptor_owner)

        admin.powers.create_with({
            plist: true, pindex: true, pshow: true, pcreate: true, pupdate: true, pdestroy: true
        }).find_or_create_by(:descriptor => descriptor_admin)

        limited.powers.create_with({
            plist: true, pindex: true, pshow: true, pcreate: true, pupdate: true, pdestroy: true
        }).find_or_create_by(:descriptor => descriptor_profile)
    end


    # initialize engines for new accounts
    def initialize_engines

        # 01.01 LesliAdmin - Lesli administration area
        if defined? LesliAdmin
            LesliAdmin::Account.create!(:account => self) if self.admin.blank?
        end

        # 03.01 LesliCalendar - Unified calendar app
        if defined? LesliCalendar
            LesliCalendar::Account.create!(:account => self) if self.calendar.blank?
        end

        # 03.05 LesliLetter - Notes & Notebooks
        if defined? LesliLetter
            LesliLetter::Account.create!(:account => self) if self.letter.blank?
        end

        # 03.06 LesliDashboard - 
        if defined? LesliDashboard
            LesliDashboard::Account.create!(:account => self) if self.dashboard.blank?
        end

        # 03.08 LesliBell - Notification system
        if defined? LesliBell
            LesliBell::Account.create!(:account => self) if self.bell.blank?
        end

        # 05.02 LesliAudit - System analytics
        if defined? LesliAudit
            LesliAudit::Account.create!(:account => self) if self.audit.blank?
        end

        # 07.02 LesliSupport - Support Ticket System
        if defined? LesliSupport
            LesliSupport::Account.create!(:account => self) if self.support.blank?
        end

        # 08.02 LesliSecurity - Users, Privileges & Access Management
        if defined? LesliGuard
            LesliGuard::Account.create!(:account => self) if self.guard.blank?
        end

    end
end
