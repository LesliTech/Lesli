=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
                return 0 unless defined? CloudHelp
                CloudHelp::Ticket.count(current_user)
            end

            def self.options(current_user, query)
                return {} unless defined? CloudHelp
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
