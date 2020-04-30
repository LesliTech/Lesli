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
    class Activity < ApplicationRecord
        self.abstract_class = true

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
            action_email_sent:              "action_email_sent"
        }

    end
end
    