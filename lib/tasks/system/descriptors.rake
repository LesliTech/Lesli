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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

namespace :system do
    namespace :descriptors do

        desc "Build descriptors and privileges according to the app controllers"
        task build: :environment do

            L2.msg("Registering Descriptor privileges")

            profile_descriptors = Descriptor.where(name: "profile")
            profile_descriptors.each do |descriptor|
                DescriptorServices.add_profile_privileges(descriptor)
            end

            owner_admin_descriptors = Descriptor.where(name: ["owner", "sysadmin"])
            owner_admin_descriptors.each do |descriptor|
                DescriptorServices.add_owner_privileges(descriptor)
            end

            # Synchronize privileges cache for all the roles
            Role::PrivilegeServices.new(Role.all).synchronize
        end
    end
end
