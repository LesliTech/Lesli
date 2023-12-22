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

# · 
namespace :lesli do 
    namespace :privileges do

        desc "Syncing privileges for all the available roles"
        task :build => :environment do |task, args|
            role_sync_privileges()
        end
    end

    # Drop, build, migrate & seed database (development only)
    def role_sync_privileges

        L2.msg("Syncing privileges for all the available roles")

        Lesli::Descriptor.where(:name => "owner").each do |descriptor|
            descriptor.initialize_descriptor_privileges
        end

        Lesli::RolePowerOperator.new(Lesli::Role.all.pluck(:id)).synchronize
    end
end
