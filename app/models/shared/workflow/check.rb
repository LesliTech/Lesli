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
module Shared
    class Workflow::Check < ApplicationLesliRecord
        self.abstract_class = true

        enum user_type: {
            any: "any",
            custom: "custom",
            creator: "creator",
            main: "main"
        }

        def self.index(workflow)
            dynamic_info_ = self.dynamic_info
            module_name = dynamic_info_[:module_name]
            full_module_name = dynamic_info_[:full_module_name].underscore

            workflow.checks.joins(
                "inner join #{full_module_name}_workflow_statuses WSI on WSI.id = #{full_module_name}_workflow_checks.initial_status_id"
            ).joins(
                "left join #{full_module_name}_workflow_statuses WSF on WSF.id = #{full_module_name}_workflow_checks.final_status_id"
            ).joins(
                "left join roles r on r.id = #{full_module_name}_workflow_checks.roles_id"
            ).joins(
                "left join users u on u.id = #{full_module_name}_workflow_checks.users_id"
            ).joins(
                "left join user_details ud on u.id = ud.users_id"
            ).select(
                "#{full_module_name}_workflow_checks.id",
                "#{full_module_name}_workflow_checks.name",
                "#{full_module_name}_workflow_checks.user_type",
                "WSI.name as initial_status_name",
                "WSF.name as final_status_name",
                "#{full_module_name}_workflow_checks.active",
                "#{full_module_name}_workflow_checks.roles_id as role_id",
                "r.name as role_name",
                "#{full_module_name}_workflow_checks.users_id as user_id",
                "concat(ud.first_name, ' ', ud.last_name) as user_name"
            ).order(id: :asc)
        end

        def show(current_user, query)
            data = self.attributes
            data["user_name"] = user.full_name if user

            data
        end

        def self.options(current_user, query, workflow)
            statuses = {}

            workflow.statuses.order(number: :asc).each do |status|
                next_statuses = []
                if status.next_statuses
                    next_statuses = status.next_statuses.split("|").map do |next_status|
                        next_status.to_i
                    end
                end

                statuses[status.id] = {
                    id: status.id,
                    name: status.name,
                    number: status.number,
                    next_statuses: next_statuses
                }
            end

            users = current_user.account.users.select(
                :id,
                :name
            )

            {
                users: users,
                roles: current_user.account.roles.select(:id, :name),
                statuses: statuses,
                user_types: self.user_types.map { |key,value| {value: key, text: value} }
            }
        end

        protected

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::Check < Shared::Workflow::Check
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            {
                module_name: module_name,
                full_module_name: module_info[0],
                engine_name: module_info[0]
            }
        end
    end
end
