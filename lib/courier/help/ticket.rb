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
    module Help
        class Ticket

            def self.with_deadline(current_user, query)
                return [] unless defined? CloudHelp
                
                today = Time.now
                filter_year = query[:filters][:year] || today.strftime("%Y")
                filter_month = query[:filters][:month] || today.strftime("%m")
                filter_day = query[:filters][:day]

                tickets = current_user.account.help.tickets
                .select(:id, :subject, :description, :deadline)
                .where("cloud_help_tickets.deadline is not null")
                .where("extract('year' from cloud_help_tickets.deadline) = ?", filter_year)
                .where("extract('month' from cloud_help_tickets.deadline) = ?", filter_month)

                tickets = tickets.where("extract('day' from cloud_help_tickets.deadline) = ?", filter_day) if filter_day

                return tickets
            end

        end
    end
end
