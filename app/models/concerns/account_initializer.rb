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

        # create initial descriptors
        descriptor_owner = self.descriptors.find_or_create_by(name: "owner")
        descriptor_admin = self.descriptors.find_or_create_by(name: "admin")
        descriptor_profile = self.descriptors.find_or_create_by(name: "profile")

        # create default roles for the new account
        owner = self.roles.create({ name: "owner", active: true, object_level_permission: 2147483647 })

        # platform administrator role
        admin = self.roles.create({ name: "admin", active: true, object_level_permission: 100000 })

        # access only to user profile
        limited = self.roles.create({ name: "limited", active: true, object_level_permission: 10, path_default: "/administration/profile" })

        # assign descriptors with appropriate privileges
        owner.powers.create(:descriptor => descriptor_owner, :plist => true, :pindex => true, :pshow => true, :pcreate => true, :pupdate => true, :pdestroy => true)
        admin.powers.create(:descriptor => descriptor_admin, :plist => true, :pindex => true, :pshow => true, :pcreate => true, :pupdate => true, :pdestroy => true)
        limited.powers.create(:descriptor => descriptor_profile, :plist => true, :pindex => true, :pshow => true, :pcreate => true, :pupdate => true, :pdestroy => true)
    end


    # initialize engines for new accounts
    def initialize_engines

        # 01.01 LesliAdmin - Lesli administration area
        if defined? LesliAdmin
            if self.admin.blank?
                self.admin = LesliAdmin::Account.new
                self.admin.account = self
                self.admin.save!
            end
        end

        # 03.01 LesliDriver - Unified calendar app
        if defined? LesliDriver
            if self.driver.blank?
                self.driver = LesliDriver::Account.new
                self.driver.account = self
                self.driver.save!
            end
        end

        # 03.05 LesliNotes - Notes & Notebooks
        if defined? LesliLetter
            if self.letter.blank?
                self.letter = LesliLetter::Account.new
                self.letter.account = self
                self.letter.save!
            end
        end

        # 05.02 LesliAudit - System analytics
        if defined? LesliAudit
            if self.audit.blank?
                self.audit = LesliAudit::Account.new
                self.audit.account = self
                self.audit.save!
            end
        end

        # 07.02 LesliHelp - Support Ticket System
        if defined? LesliHelp
            if self.help.blank?
                self.help = LesliHelp::Account.new
                self.help.account = self
                self.help.save!
            end
        end

        # 08.01 LesliGuard - Security Management Module
        if defined? LesliGuard
            if self.guard.blank?
                self.guard = LesliGuard::Account.new
                self.guard.account = self
                self.guard.save!
            end
        end

        # 
        if defined? LesliSupport
            if self.support.blank?
                self.support = LesliSupport::Account.new
                self.support.account = self
                self.support.save!
            end
        end
    end
end
