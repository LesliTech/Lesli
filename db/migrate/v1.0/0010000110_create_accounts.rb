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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class CreateAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :accounts do |t|
            
            # account status
            t.integer   :status

            # company information
            t.string    :company_name
            t.string    :company_name_legal
            t.string    :company_tag_line

            # location
            t.integer   :country
            t.string    :address
            t.string    :region
            t.string    :city
            t.string    :postal_code

            # contact details
            t.string    :website
            t.string    :phone_number_1
            t.string    :phone_number_2
            t.string    :phone_number_3
            t.string    :phone_number_4
            t.string    :public_email

            # social media
            t.string    :github
            t.string    :twitter
            t.string    :youtube
            t.string    :linkedin
            t.string    :facebook

            t.timestamps
            
        end
    end
end
