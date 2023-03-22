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


L2.msg "Loading production users:"


# get the email from the settings
account = Rails.application.config.lesli[:account]


# try to extract the domain name from the main email address
email_domain = account[:email].scan(/.*@(\S+)/)&.first&.first


# build a random password for the owner and guest users
passowner = Devise.friendly_token(40)
passguest = Devise.friendly_token(40)


# get the emails for the initial accounts
emailowner = account[:email]
emailguest = "guest@#{email_domain}"


# create the owner user for the account
user = create_development_user(["owner", nil, account[:name], "", emailowner], passowner)
user.account.user = user
user.account.save!


# create a guest account (used for appstore & playstore validation)
create_development_user(["sysadmin", nil, "Guest", "Agent", emailguest], passguest) if email_domain


# print some separators so will be easy to find these messages later
L2.br(5); L2.br; L2.line; L2.line; L2.line; L2.line; 


# print the owner user credentials, so we can save those credentials
L2.success(
    "Owner user created successfully with email: #{emailowner} and password: #{passowner}",
    "Admin user created successfully with email: #{emailguest} and password: #{passguest}"
)


# print some separators so will be easy to find these messages later
L2.br; L2.line; L2.line; L2.line; L2.line; L2.br(5);


# IMPORTANT: The aditional production users must be loaded from builder engine seeder
