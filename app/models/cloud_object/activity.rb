=begin

Copyright (c) 2020, all rights reserved.

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

module CloudObject
    class Activity < ApplicationLesliRecord
        self.abstract_class = true
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id", optional: true

        # This enum can be overrided by the model that inherits from CloudObject::Activity
        enum category: {
            action_list:                    "action_list",
            action_create:                  "action_create",
            action_show:                    "action_show",
            action_update:                  "action_update",
            action_destroy:                 "action_destroy",
            action_status:                  "action_status",
            action_workflow_action_failed:  "action_workflow_action_failed",
            action_email_sent:              "action_email_sent",
            action_create_file:             "action_create_file",
            action_destroy_file:            "action_destroy_file"
        }

        # @return [User] This method will always return nil
        # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
        #   ApplicationLesliRecord will work without issues
        def user_main
            return nil
        end

        # @return [Class] The class of the association 'belongs_to'
        # @description All activities belong to a *cloud_object*. This method returns the specific class of
        #     that cloud_object.
        # @example
        #     puts DeutscheLeibrenten::Project::Activity.cloud_object_model.new # This will display an instance of DeutscheLeibrenten::Project
        def self.cloud_object_model
            self.reflect_on_association(:cloud_object).klass
        end

    end
end
    