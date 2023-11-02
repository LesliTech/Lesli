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

module Lesli
    class Descriptor < ApplicationLesliRecord
        belongs_to :account
        has_many :privileges
        #has_many :role_descriptors

        # this scope is needed to allow to join with deleted descriptors
        # join with deleted descriptors is needed to know which privileges we have to remove from the
        # role_privileges table when a descriptor is removed from role_describers
        has_many :role_descriptors_all, -> { with_deleted }, foreign_key: "descriptors_id", class_name: "Role::Descriptor"
        
        validates :name, presence: true

        after_create :initialize_descriptor_privileges

        def initialize_descriptor_privileges

            descriptor_operator = DescriptorPrivilegeOperator.new(self)
    
            descriptor_operator.add_profile_privileges(self) if self.name == "profile"
    
            descriptor_operator.add_owner_privileges(self) if ["owner", "sysadmin"].include?(self.name)
    
        end
    end
end
