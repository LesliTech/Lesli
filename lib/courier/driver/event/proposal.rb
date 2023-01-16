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
    module Driver
        class Event::Proposal

            def self.create(current_user, events_id, event_proposal_params)
                return nil unless defined? CloudDriver

                # Using the CloudDriver services to create the event proposal
                CloudDriver::Event::ProposalServices.create(current_user, events_id, event_proposal_params)
            end

        end
    end
end
