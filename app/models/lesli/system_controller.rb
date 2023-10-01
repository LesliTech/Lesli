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
    class SystemController < ApplicationLesliRecord
        has_many :actions

        def self.index matrix:false

            # get a matrix of controllers and actions
            c = SystemController.joins(:actions).select(
                "lesli_system_controllers.engine as engine",
                "lesli_system_controllers.reference as controller",
                "lesli_system_controllers.name as controller_name",
                "lesli_system_controllers.id as controller_id",
                "lesli_system_controller_actions.name as action",
                "lesli_system_controller_actions.id as action_id",
                "case lesli_system_controller_actions.name
                    when 'index'   then 1
                    when 'show'    then 2
                    when 'new'     then 3
                    when 'edit'    then 4
                    when 'create'  then 5
                    when 'update'  then 6
                    when 'destroy' then 7
                    when 'options' then 8
                    else 9
                end as importance
                "
            )
            .where("lesli_system_controllers.deleted_at is NULL")
            #.where("system_controller_actions.name in ('index', 'create', 'update', 'show', 'destroy')")
            #.order("system_controllers.name, importance, system_controller_actions.name")
            .order("importance DESC")
    
            return c unless matrix
    
            cc = {}
    
            # convert the matrix to a hash of engines with controllers and available actions as values
            # example:
            #   my_engine: { my_controller: [ my list of actions ]}
            c.each do |c|

                engine = c[:engine]
                controller = c[:controller]
    
                # create a uniq container for every action that belongs to a specific controller
                if cc[engine].blank?
                    cc[engine] = {}
                end

                # create a uniq container for every action that belongs to a specific controller
                if cc[engine][controller].blank?
                    cc[engine][controller] = { 
                        id: c[:controller_id], 
                        name: c[:controller_name], 
                        actions: []
                    } 
                end

                # push every action to his specic controller
                cc[engine][controller][:actions].push({ 
                    id: c[:action_id], 
                    action: c[:action]
                })
            end
    
            return cc
    
        end
    end
end
