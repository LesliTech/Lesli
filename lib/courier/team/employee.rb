=begin

Copyright (c) 2022, all rights reserved.

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
    module Team
        class Employee
            def self.all()

                employees = []

                users = ::User.left_joins(:detail).select(:id, :email, :first_name, :last_name, :created_at).order(:id)

                if defined?(CloudTeam)
                    employees = ::CloudTeam::Employee.all
                end

                #users | employees returns a new array with the combination of users and employess

                users

            end

            def self.index(current_user, query)
                return [] unless defined? CloudTeam
                CloudTeam::Employee.index(current_user, query)
            end

            def self.show(current_user, query, employees_id)
                return {} unless defined? CloudTeam
                employee = current_user.account.team.employees.find_by_id(employees_id)
                return nil unless employee

                employee.show(current_user, query)
            end

            def self.find(current_user, id)
                return {} unless defined? CloudTeam
                CloudTeam::EmployeeServices.new(current_user).find(id)
            end

            def self.create(current_user, params)
                return unless defined? CloudTeam
                CloudTeam::EmployeeServices.new(current_user).create(params)
            end

            def self.update(current_user, id, params)
                return nil unless defined? CloudTeam

                employee = CloudTeam::EmployeeServices.new(current_user).find(id)
                return nil unless employee.found?

                employee.update(params)
            end

            def self.destroy(current_user, id)
                return nil unless defined? CloudTeam

                employee = CloudTeam::EmployeeServices.new(current_user).find(id)
                return nil unless employee.found?

                employee.destroy
            end
        end
    end
end
