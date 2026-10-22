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
account = Lesli::Account.find_by!(email: Lesli.config.company.fetch(:email))


# extract the domain name from the main email address
email_domain = account.email.to_s.split("@", 2).second
raise ArgumentError, "The account email must include a domain" if email_domain.blank?


# get the emails for the initial accounts
emailowner = account.email
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
create_account_user(account: account, email: emailowner, role_name: "owner", first_name: "Owner", last_name: account.name, password: passowner)
create_account_user(account: account, email: emailadmin, role_name: "admin", first_name: "Admin", last_name: account.name, password: passadmin)
create_account_user(account: account, email: emailguest, role_name: "guest", first_name: "Guest", last_name: account.name, password: passguest)


# print some separators so will be easy to find these messages later
Termline.br(2);
