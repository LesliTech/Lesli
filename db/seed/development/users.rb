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

# get settings
account_logins = Rails.application.config.lesli_settings["configuration"]["security"]["login"]

# create development users
account_logins.each do |account_login|
    LC::Debug.msg account_login, account_login["password"]
    User.find_or_create_by(email: account_login["username"]) do |user|
        user.role = Role.first
        user.password = account_login["password"] + Time.now.year.to_s
        user.password_confirmation = account_login["password"] + Time.now.year.to_s
        user.account = Account.first
        user.confirm if not user.confirmed?
        user.save!
        user.detail.first_name = account_login["fullname"] if not user.detail.blank?

        user.account.user = user
        user.account.save!
    end
end

puts "Users successfully created!"
