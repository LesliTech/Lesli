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
        class Leave

            def self.index(current_user, query)
                return [] unless defined? CloudTeam
                CloudTeam::Leave.index(current_user, query)
            end

            def self.show(current_user, query, leaves_id)
                return {} unless defined? CloudTeam
                leave = current_user.account.team.leaves.find_by_id(leaves_id)
                return nil unless leave

                leave.show(current_user, query)
            end

            def self.create(current_user, leave_params)
                return nil unless defined? CloudTeam
                CloudTeam::LeaveService.create(current_user, leave_params)
            end

            def self.update(current_user, leaves_id, leave_params)
                return {} unless defined? CloudTeam
                leave = current_user.account.team.leaves.find_by_id(leaves_id)
                return {} unless leave

                CloudTeam::LeaveService.update(current_user, leave, leave_params)
            end

        end
    end
end
