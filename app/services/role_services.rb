=begin

Copyright (c) 2023, all rights reserved.

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

class RoleServices < LesliServices


    # Return a list of roles that the user is able to work with
    # according to object level permission
    def list query=nil, params=nil

        # get the max object level permission assigned to user through roles
        role_max = current_user.roles.map(&:object_level_permission).max()

        roles = current_user.account.roles
        .where("object_level_permission <= ?", role_max)
        .order(object_level_permission: :desc, name: :asc)
        .select(:id, :name, :object_level_permission)
        
    end


    # @return [Array] Paginated index of users.
    # @description Return a paginated array of users, used mostly in frontend views
    def index query, params

    end


    # Creates a query that selects all user information from several tables if CloudLock is present
    def show (user=nil)

    end

    def create user_params

    end

    def update params

    end

    def find id
        self.resource = current_user.account.users.joins(:detail).find_by(id: id)
        self
    end
end
