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

module Courier

    module Core

        class Users

            def self.list()

                employees = []
                if defined? (CloudLock)
                    return ::User.left_joins(:detail).select(:id, :email, :role, :first_name, :last_name, :created_at).order(:id)
                else
                    return ::User.select(:id, :email, :role, :created_at, :name).order(:id)
                end


                if defined?(CloudTeam)
                    employees = ::CloudTeam::Employee.all
                end

                #users | employees returns a new array with the combination of users and employess

                users

            end

            def self.get(id)
                if defined? (CloudLock)
                    return ::User.lock.joins(:detail).select(:id, :email, :role, :first_name, :last_name, :created_at).find(id)
                else
                    return ::User.select(:id, :email, :role, :name, :created_at).find(id)
                end
            end

        end

    end
    
end
