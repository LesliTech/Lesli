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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Descriptor::Privilege < ApplicationLesliRecord
    belongs_to :descriptor
    belongs_to :system_controller_action, class_name: "SystemController::Action"

    def self.index current_user, query, params 

        # First we create a pivot table to convert from:
        # controller_id
        # list
        # index
        # show
        # create
        # update
        # destroy
        # to:
        # controller_id | list | index | show | create | update | destroy |
        # so this is more easy to manage by the API clients
        privileges_pivot = SystemController.joins(:actions)
        .where("system_controller_actions.deleted_at IS NULL")
        .group(:system_controller_id)
        .select(
            :system_controller_id,
            "MAX(CASE WHEN system_controller_actions.name = 'list'    THEN system_controller_actions.id end) AS list_action",
            "MAX(CASE WHEN system_controller_actions.name = 'index'   THEN system_controller_actions.id end) AS index_action",
	        "MAX(CASE WHEN system_controller_actions.name = 'show'    THEN system_controller_actions.id end) AS show_action",
	        "MAX(CASE WHEN system_controller_actions.name = 'create'  THEN system_controller_actions.id end) AS create_action",
            "MAX(CASE WHEN system_controller_actions.name = 'update'  THEN system_controller_actions.id end) AS update_action",
            "MAX(CASE WHEN system_controller_actions.name = 'destroy' THEN system_controller_actions.id end) AS destroy_action"
        )

        # We join to the SystemControllers table again to get the controller name
        # IMPORTANT: We dont get the name from the previos SQL query due we dont want to group by the name string
        # then we have to join to the descriptor_privileges table six times (one time for every action, list, index, etc)
        # we have to do that due we need to check which privileges we have activated
        # later in the select statement we get the id for the list action and if the id is not null get true/false if 
        # action is assigned to the descriptor privileges
        # we remove the nulls using "attributes.compact" it is important to remove all the nulls due a null action id
        # means the specific action is not implemented in any application routes, which means there is no view, controller
        # or model defined for that action
        SystemController.joins("INNER JOIN (#{privileges_pivot.to_sql}) privileges ON privileges.system_controller_id = system_controllers.id")
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_list    on dp_list.descriptor_id =    ? and dp_list.system_controller_action_id = privileges.list_action", params[:descriptor_id]]))
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_index   on dp_index.descriptor_id =   ? and dp_index.system_controller_action_id =   privileges.index_action", params[:descriptor_id]]))
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_show    on dp_show.descriptor_id =    ? and dp_show.system_controller_action_id =    privileges.show_action", params[:descriptor_id]]))
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_create  on dp_create.descriptor_id =  ? and dp_create.system_controller_action_id =  privileges.create_action", params[:descriptor_id]]))
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_update  on dp_update.descriptor_id =  ? and dp_update.system_controller_action_id =  privileges.update_action", params[:descriptor_id]]))
        .joins(sanitize_sql_array(["left join descriptor_privileges dp_destroy on dp_destroy.descriptor_id = ? and dp_destroy.system_controller_action_id = privileges.destroy_action", params[:descriptor_id]]))
        .order(:name)
        .select(
            "name as controller",

            "privileges.list_action",
            "case when privileges.list_action is not null then case when dp_list.system_controller_action_id is null then false else true end end as list_active",
            
            "privileges.index_action",
            "case when privileges.index_action is not null then case when dp_index.system_controller_action_id is null then false else true end end as index_active",

            "privileges.show_action",
            "case when privileges.show_action is not null then case when dp_show.system_controller_action_id is null then false else true end end as show_active",
            
            "privileges.create_action",
            "case when privileges.create_action is not null then case when dp_create.system_controller_action_id is null then false else true end end as create_active",
            
            "privileges.update_action",
            "case when privileges.update_action is not null then case when dp_update.system_controller_action_id is null then false else true end end as update_active",
            
            "privileges.destroy_action",
            "case when privileges.destroy_action is not null then case when dp_destroy.system_controller_action_id is null then false else true end end as destroy_active",
        ).map do |privilege|
             privilege.attributes.compact
        end
    end
end
