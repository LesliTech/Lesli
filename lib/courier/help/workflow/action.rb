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

module Courier
    module Help
        module Workflow
            class Action

                def self.execute_actions(current_user, cloud_object, old_attributes, new_attributes)
                    return nil unless defined? CloudHelp
                    CloudHelp::Workflow::Action.execute_actions(current_user, cloud_object, old_attributes, new_attributes)
                end

            end
        end
    end
end
