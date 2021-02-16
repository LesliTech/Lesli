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

class LesliMailerPreview < ActionMailer::Preview

    def simple
        LesliMailer.with(user: User.first).simple
    end

    def multiple
        LesliMailer.with(
            user: User.first,
            to: [User.find(1), User.find(2)],
            cc: [User.find(3), User.find(4)],
            bcc: [User.find(5), User.find(5)]
        )
    end

end
