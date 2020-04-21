=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module Courier

    module Lesli

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
                    return ::User.left_joins(:detail).select(:id, :email, :role, :first_name, :last_name, :created_at).find(id)
                else
                    return ::User.select(:id, :email, :role, :name, :created_at).find(id)
                end
            end

        end

    end
    
end