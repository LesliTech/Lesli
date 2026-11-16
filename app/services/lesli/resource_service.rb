=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class ResourceService < Lesli::ApplicationLesliService
        def index(matrix: false)

            actions = Resource.actions.joins(:parent).select(
                "parents_lesli_resources.engine as engine",
                "parents_lesli_resources.route as route",
                "parents_lesli_resources.identifier as controller",
                "parents_lesli_resources.label as controller_name",
                "parents_lesli_resources.id as controller_id",
                "lesli_resources.action as action",
                "lesli_resources.id as action_id",
                "case lesli_resources.action
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
            .where("parents_lesli_resources.deleted_at is NULL")
            .order("importance DESC")
    
            return actions unless matrix

            actions.each_with_object({}) do |action, engines|
                controllers = (engines[action[:engine]] ||= {})
                controller = (controllers[action[:controller]] ||= {
                    id: action[:controller_id],
                    name: action[:controller_name],
                    route: action[:route],
                    actions: []
                })
                controller[:actions] << { id: action[:action_id], action: action[:action] }
            end
        end
    end
end
