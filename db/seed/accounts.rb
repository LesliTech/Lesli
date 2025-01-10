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


# get settings
company = Lesli.config.company


# create account
account = Lesli::Account.find_or_create_by(email: company[:email]) do |account|
    account.name = company[:name]
    account.status = 'active'
    account.save!

    # account.detail.company_name = company[:name]
    # account.detail.public_email = company[:email]
    # account.detail.company_tagline = company[:tag_line] || ""
    # #account.registered!
    # account.detail.save!

end

# print some separators so will be easy to find these messages later
L2.br(5); L2.br; L2.line; L2.line; L2.line; L2.line; 
L2.success("Account #{ account.name } <#{ account.email }> successfully created!")
