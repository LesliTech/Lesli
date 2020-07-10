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

module CloudObject
    class Activity < ApplicationLesliRecord
        self.abstract_class = true
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id", optional: true

        # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
        #   ApplicationLesliRecord will work without issues
        def user_main
            return nil
        end

        enum icon: {
            flag: "flag"
        }

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

    end
end
    