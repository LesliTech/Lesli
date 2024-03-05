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


L2.msg "Loading production users:"


# get the account information
account = Lesli::Account.first


# try to extract the domain name from the main email address
email_domain = account[:email].scan(/.*@(\S+)/)&.first&.first


# get the emails for the initial accounts
emailowner = account[:email]
emailadmin = "admin@#{email_domain}"
emailguest = "guest@#{email_domain}"


# build a random password for the owner, admin and guest users
passowner = Devise.friendly_token(40)
passadmin = Devise.friendly_token(40)
passguest = Devise.friendly_token(40)


# create the owner user for the account, 
userowner = create_development_user(emailowner, "owner", "Owner", account[:company_name], password:passowner)
useradmin = create_development_user(emailadmin, "admin", "Admin", account[:company_name], password:passadmin)
userguest = create_development_user(emailguest, "limited", "Guest", account[:company_name], password:passguest)


# print some separators so will be easy to find these messages later
L2.br(5); L2.br; L2.line; L2.line; L2.line; L2.line; 


# print the owner user credentials, so we can save those credentials
L2.success(
    "Owner user created successfully with email: #{emailowner} and password: #{passowner}",
    "Admin user created successfully with email: #{emailadmin} and password: #{passadmin}",
    "Admin user created successfully with email: #{emailguest} and password: #{passguest}"
)


# print some separators so will be easy to find these messages later
L2.line; L2.line; L2.line; L2.line; L2.br(5);L2.br(5);
