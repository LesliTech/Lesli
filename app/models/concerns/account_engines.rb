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

module AccountEngines
    extend ActiveSupport::Concern


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

        # 08.03 LesliAudit - System analytics
        if defined? LesliAudit
            if self.audit.blank?
                self.audit = LesliAudit::Account.new
                self.audit.account = self
                self.audit.save!
            end
        end
    end
end
