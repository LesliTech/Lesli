=begin

Copyright (c) 2020, all rights reserved.

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

class User::Role < ApplicationRecord
    belongs_to :user, foreign_key: "users_id"
    belongs_to :roles, foreign_key: "roles_id", class_name: "::Role"
    belongs_to :role, foreign_key: "roles_id", class_name: "::Role"
    has_many :privileges,  through: :roles
end