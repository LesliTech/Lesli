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
class UserMailerPreview < ActionMailer::Preview

    def welcome
        UserMailer.with(user: User.first).welcome
    end

    def reset_password_instructions
        UserMailer.with(
            user: User.first, 
            token: "my_reset_password_token"
        ).reset_password_instructions
    end

end
