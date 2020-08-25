=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

# get settings
account_logins = Rails.application.config.lesli_settings["configuration"]["security"]["login"]

# create development users
account_logins.each do |account_login|
    User.find_or_create_by(email: account_login["username"]) do |user|
        user.role = Role.find(1)
        user.password = account_login["password"]
        user.password_confirmation = account_login["password"]
        user.accounts_id = 1
        user.confirm if not user.confirmed?

        user.detail.first_name = account_login["fullname"] if not user.detail.blank?

        user.account.user = user
        user.account.save!
    end
end

puts "Users successfully created!"
