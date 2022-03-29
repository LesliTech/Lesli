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

            def self.index(current_user, query)
                return [] unless defined? CloudHelp
                CloudHelp::Ticket.index(current_user, query)
            end

            def self.show(current_user, query, tickets_id)
                return [] unless defined? CloudHelp
                ticket = CloudHelp::Ticket.find(tickets_id)
                ticket.show(current_user, query)
            end

            def self.create(current_user, ticket_params)
                return nil unless defined? CloudHelp
                CloudHelp::TicketServices.create(current_user, ticket_params)
            end

            def self.with_deadline(current_user, query)
                return [] unless defined? CloudHelp
                CloudHelp::Ticket.tickets_with_deadline(current_user, query)
            end

            def self.count(current_user)
                return 0 if not defined? CloudHelp
                CloudHelp::Ticket.count(current_user)
            end

            def self.options(current_user, query)
                return {} if not defined? CloudHelp
                CloudHelp::Ticket.options(current_user, query)
            end

            def self.destroy(current_user, ticket_id)
                return nil unless defined? CloudHelp
                ticket = CloudHelp::Ticket.find_by_id(ticket_id)
                CloudHelp::TicketServices.destroy(current_user, ticket)
            end

            def self.update(current_user, ticket_id, ticket_params)
                return {} unless defined? CloudHelp
                ticket = CloudHelp::Ticket.find_by_id(ticket_id)
                CloudHelp::TicketServices.update(current_user, ticket, ticket_params)
            end
        end
    end
end
