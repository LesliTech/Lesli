=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module House
        class Project

            def self.list(current_user)
                return [] unless defined? CloudHouse

                main_owner_role = CloudHouse::Project::Customer.roles["main_owner"]
                projects = current_user.account.house.projects
                .select("cloud_house_projects.id, concat(CHPRD.city, ' - ', CHCD.last_name, '', CHCD.first_name) as text")
                .joins("inner join cloud_house_project_customers CHPC on CHPC.cloud_house_projects_id = cloud_house_projects.id")
                .joins("inner join cloud_house_contacts CHC on CHC.id = CHPC.cloud_house_contacts_id")
                .joins("inner join cloud_house_contact_details CHCD on CHC.id = CHCD.cloud_house_contacts_id")
                .joins("inner join cloud_house_properties CHPR on CHPR.id = cloud_house_projects.cloud_house_properties_id")
                .joins("inner join cloud_house_property_details CHPRD on CHPR.id = CHPRD.cloud_house_properties_id")
                .joins("inner join cloud_house_workflow_statuses CHWS on CHWS.id = cloud_house_projects.cloud_house_workflow_statuses_id")
                .where("CHWS.name != ? AND CHWS.name != ? AND CHWS.name != ?", 'not_interested', 'customer_has_rejected', 'customer_was_rejected')
                .where("CHPC.role = #{main_owner_role}")

                projects
            end

            def self.create_activity(activity_params)
                return unless defined? CloudHouse

                activity = CloudHouse::Project::Activity.create(activity_params)
            end

        end
    end
end
