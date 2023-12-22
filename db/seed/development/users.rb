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


# Create company user
user = create_development_user(company[:email], "owner", company[:name], "")
user.account.user = user
user.account.save!


# core development users
[
    ["ldonis@lesli.tech", "owner",  "Luis", "Donis"],
    ["admin@lesli.tech", "sysadmin","Admin","Lesli"],
    ["guest@lesli.tech", "limited", "Guest","Lesli"],
    ["test@lesli.tech", "sysadmin", "Test", "Lesli"],
].each do |user|
    create_development_user(user[0], user[1], user[2], user[3])
end 
