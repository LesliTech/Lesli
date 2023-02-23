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

module Courier
    module Time
        class TimeRecord

            def self.find(current_user, id)
                return {} unless defined? CloudTime
                CloudTime::TimeRecordServices.new(current_user).find(id)
            end
            
            def self.index(current_user, query)
                return {} unless defined? CloudTime
                CloudTime::TimeRecordServices.new(current_user, query).index
            end

            def self.create(current_user, params)
                return unless defined? CloudTime
                CloudTime::TimeRecordServices.new(current_user).create(params)
            end

            def self.update(current_user, id, params)
                return unless defined? CloudTime
                CloudTime::TimeRecordServices.new(current_user).update(id, params)
            end
        end
    end
end
