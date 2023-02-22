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


# Company development user
account = Rails.application.config.lesli.dig(:account)
user = create_development_user(["owner", nil, account[:name], "", account[:email]])
user.account.user = user
user.account.save!


# core development users
[
    ["owner",    "mr", "SysAdmin", "user", "hello@lesli.cloud"],
    ["sysadmin", "mr", "SysAdmin", "user", "admin@lesli.cloud"],
    ["limited",  "mr", "Guest",    "user", "guest@lesli.cloud"],
    ["sysadmin", "mr", "Test",     "user", "test@lesli.cloud"],
].each do |user|
    create_development_user(user)
end
