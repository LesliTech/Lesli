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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end



# get the account information
account = Lesli::Account.first


# try to extract the domain name from the main email address
email_domain = account[:email].scan(/.*@(\S+)/)&.first&.first


# get the emails for the initial accounts
emailowner = account[:email]
emailadmin = "admin@#{email_domain}"
emailguest = "guest@#{email_domain}"


# Use the default password for development
passowner = Lesli.config.security.dig(:password)
passadmin = passowner
passguest = passowner


# build a random password for the owner, admin and guest users
# only for production and only when LesliShield is installed and
# only if the "demo mode" is not active in the 
# config/initializers/lesli.rb file
if Rails.env.production? && defined?(LesliShield) && !Lesli.config.demo
    passowner = LesliShield::Tokens.friendly_token
    passadmin = LesliShield::Tokens.friendly_token
    passguest = LesliShield::Tokens.friendly_token
end


# create the owner user for the account, 
userowner = create_account_user(emailowner, "owner", "Owner", account[:company_name], passowner)
useradmin = create_account_user(emailadmin, "admin", "Admin", account[:company_name], passadmin)
userguest = create_account_user(emailguest, "limited", "Guest", account[:company_name], passguest)


# print the owner user credentials, so we can save those credentials
L2.success(
    "Owner user created successfully with email: #{emailowner} and password: #{passowner}",
    "Admin user created successfully with email: #{emailadmin} and password: #{passadmin}",
    "Admin user created successfully with email: #{emailguest} and password: #{passguest}"
)


# print some separators so will be easy to find these messages later
L2.line; L2.line; L2.line; L2.line; L2.br(5);L2.br(5);
