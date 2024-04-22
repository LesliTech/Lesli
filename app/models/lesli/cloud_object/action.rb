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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
