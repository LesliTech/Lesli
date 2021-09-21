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

module Courier
    module Audit
        module Insights
            class Users
                def self.index(current_user, query)
                    return [] unless defined? CloudAudit
                    cat = query.dig(:filters, :cat)
                    return CloudAudit::Insights::User.by_role(current_user, query) if cat == "by_role"
                    return CloudAudit::Insights::User.by_role_date(current_user, query) if cat == "by_role_date"
                    if !cat 
                        return {
                            :by_role => CloudAudit::Insights::User.by_role(current_user, query),
                            :by_role_date => CloudAudit::Insights::User.by_role_date(current_user, query),
                        }
                    end
                end
            end
        end
    end
end
