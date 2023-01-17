=begin
Copyright (c) 2021, all rights reserved.

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
class SystemController < ApplicationLesliRecord
    has_many :actions,    foreign_key: "system_controllers_id"

    enum category: {
        index:   'index',
        create:  'create',
        update:  'update',
        show:    'show',
        destroy: 'destroy',
        search:  'search'
    }, _suffix: true

    def self.index current_user, query

        # get a matrix of controllers and actions
        c = SystemController.joins(:actions).select(
            "system_controllers.name as id",
            "system_controllers.name as controller",
            "system_controllers.id as controller_id",
            "system_controller_actions.name as action",
            "system_controller_actions.id as action_id",
            "case system_controller_actions.name
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
        #.where("system_controller_actions.name in ('index', 'create', 'update', 'show', 'destroy')")
        #.order("system_controllers.name, importance, system_controller_actions.name")
        .order("importance DESC")

        return c

        cc = {}

        # convert the matrix to a hash of controllers with the available actions as values
        # example:
        #   my_controller: [my list of actions]
        c.each do |c|

            # create a uniq container for every action that belongs to a specific controller
            if cc[c[:controller]].blank?
                cc[c[:controller]] = { 
                    id: c[:controller_id], 
                    name: c[:controller], 
                    actions: []
                } 
            end

            # push every action to his specic controller
            cc[c[:controller]][:actions].push({ 
                id: c[:action_id], 
                action: c[:action]
            })
        end

        # convert the hash to a simple array
        # example:
        #   from: my_controller: [my list of actions]
        #   to: [{my_controller: [my list of actions]}]
        #cc.map { |k,v| v }

        return cc

    end 

    def self.options current_user, query
        {
            categories: self.categories.map {|k, _| { label: k, value: k }}
        }
    end 
end
