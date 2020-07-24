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

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Role::Privilege < ApplicationRecord
    belongs_to :role, foreign_key: "roles_id"


    def self.index(role)
        role.privileges.select(
            :id,
            :grant_object,
            :grant_index,
            :grant_create,
            :grant_new,
            :grant_edit,
            :grant_show,
            :grant_update,
            :grant_destroy,
            :grant_options,
            :grant_resources,
            :grant_search,
            :created_at,
            :updated_at
        )
        .order(:grant_object, :id)
    end
end
