=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

namespace :app do
    namespace :descriptors do

        # standard methods must have privilege requests only to do actions related
        # for example: my show action should only required privileges to show methods
        # form other controllers.
        # list, index, show, new, create, edit, update, destroy, search
        denied_privileges_for_index =['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_show = ['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_new = ['index', 'show', 'edit', 'update', 'destroy']
        denied_privileges_for_edit = ['index', 'show', 'new', 'create', 'destroy']
        denied_privileges_for_destroy = ['index', 'show', 'new', 'create', 'edit', 'update']
        

        desc "Build descriptors and privileges according to the app controllers"
        task build: :environment do

            profile_descriptors = Descriptor.where(name: "profile")
            profile_descriptors.each do |descriptor|
                DescriptorService.add_profile_privileges(descriptor)
            end

            owner_admin_descriptors = Descriptor.where(name: ["owner", "sysadmin"])
            owner_admin_descriptors.each do |descriptor|
                DescriptorService.add_owner_privileges(descriptor)
            end

            Auth::RolePrivilegesService.new.synchronize_privileges()

        end
    end
end
