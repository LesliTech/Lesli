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

            def self.index current_user, query, params
                User.index current_user, query, params
            end

            def self.list()
                :User.list
            end

            def self.get(id)
                return ::User
                .joins("inner join user_details UD on UD.users_id = users.id")
                .joins("inner join roles R on R.id = users.roles_id")
                .joins("inner join role_details RD on RD.roles_id = R.id")
                .where(active: true)
                .select(
                    :id,
                    :roles_id,
                    :active,
                    :email,
                    "UD.first_name",
                    "UD.last_name",
                    "false as editable",
                    "CONCAT(UD.first_name, ' ',UD.last_name) as name",
                    "R.id as role_id",
                    "RD.name as role_name",
                    "UD.salutation",
                    "UD.telephone",
                    "UD.title"
                )
                .find(id)
            end

            def self.get_by_email(email)
                return ::User
                .joins("inner join user_details UD on UD.users_id = users.id")
                .joins("inner join roles R on R.id = users.roles_id")
                .joins("inner join role_details RD on RD.roles_id = R.id")
                .find_by_email(email)
            end

        end

    end
    
end
