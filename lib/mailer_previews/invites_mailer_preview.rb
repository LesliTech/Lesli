=begin
    
Copyright (c) 2021, all rights reserved.

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

class InvitesMailerPreview < ActionMailer::Preview

    def invitation_card
        InvitesMailer.with(invite: {
            email: "hello@lesli.cloud",
            full_name: "Lesli Cloud",
            telephone: "+502 5690 6973"
        }).invitation_card
    end

end
