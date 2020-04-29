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

def create_user(email, password, name)
    User.find_or_create_by(email: email) do |user|
        user.name = name
        user.role = "admin"
        user.password = password
        user.password_confirmation = password
        user.accounts_id = 1
        user.confirm

        user.account.user = user
        user.account.save!
    end
end

generated_password = Devise.friendly_token.first(32)

create_user("dev@lesli.cloud", generated_password, "Lesli Development") if defined?(LesliTech)
create_user("dev@deutsche-leibrenten.de", generated_password, "Leibrenten Development") if defined?(CloudHaus)

p "Users successfully created with password: " + generated_password
