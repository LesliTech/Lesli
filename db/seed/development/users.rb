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

# development user
user = Rails.application.config.lesli[:account][:user]

create_development_user(["owner", "mr", user[:name], "", user[:email]])

# core development users
[
    ["owner",   "mr", "Owner",   "user", "owner@lesli.cloud"],
    ["sysadmin","mr", "SysAdmin","user", "admin@lesli.cloud"],
    ["limited", "mr", "Limited", "user", "limited@lesli.cloud"],
    ["guest",   "mr", "Guest",   "user", "guest@lesli.cloud"],
    ["sysadmin","mr", "Test",    "user", "test@lesli.cloud"],
    ["api",     "mr", "API",     "user", "api@lesli.cloud"],
].each do |user|

    create_development_user(user)

end


# notify
LC::Debug.msgc "Users successfully created!"
