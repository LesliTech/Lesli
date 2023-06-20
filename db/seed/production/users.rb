=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
