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

# Company development user
account = Rails.application.config.lesli[:account]

LC::Debug.msg "Loading development users"
user = create_development_user(["owner", nil, account[:name], "", account[:email]])
user.account.user = user
user.account.save!

# core development users
[
    ["sysadmin", "mr", "SysAdmin", "user", "admin@lesli.cloud"],
    ["limited",  "mr", "Guest",    "user", "guest@lesli.cloud"],
    ["sysadmin", "mr", "Test",     "user", "test@lesli.cloud"],

    ["owner",    "mr", "Luis",      "Donis",      "ldonis@lomax.com.gt"],
    ["owner",    "mr", "Christoph", "Maichel",    "christoph.maichel@wahtari.com"],
    ["sysadmin", "mr", "Francisco", "Rosal",      "frosal@lomax.com.gt"],
    ["sysadmin", "mr", "Erick",     "Garcia",     "egarcia@lomax.com.gt"],
    ["sysadmin", "mr", "Marcos",    "Bonifasi",   "mbonifasi@lomax.com.gt"],
    ["sysadmin", "mr", "Andy",      "Castillo",   "acastillo@lomax.com.gt"],
    ["sysadmin", "ms", "Jenni",     "Sandoval",   "jsandoval@lomax.com.gt"],
].each do |user|
    create_development_user(user)
end
