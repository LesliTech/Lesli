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
class CloudObject::Action < ApplicationLesliRecord
    self.abstract_class = true

    belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

    # @return [Class] The class of the association 'belongs_to'
    # @description All actions belong to a *cloud_object*. This method returns the specific class of
    #     that cloud_object.
    # @example
    #     puts DeutscheLeibrenten::Project::File.cloud_object_model.new # This will display an instance of DeutscheLeibrenten::Project
    def self.cloud_object_model
        self.reflect_on_association(:cloud_object).klass
    end

    def self.index(curren_user, cloud_object)
        action_groups = {}
        cloud_object.actions.order(group: :asc).map do |action|
            action_attributes = action.attributes.merge({
                "user_creator_name" => action.user_creator.full_name,
                "created_at_text" => LC::Date.to_string(action.created_at)
            })
            action_groups[action.group] = [] unless action_groups[action.group]
            
            action_groups[action.group].push(action_attributes)
        end

        action_groups
    end

    def show(current_user)
        attributes.merge({
            "user_creator_name" => user_creator.full_name,
            "created_at_text" => LC::Date.to_string(created_at)
        })
    end
end
