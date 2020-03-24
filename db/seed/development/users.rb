=begin

Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@author   Luis Donis <ldonis@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 1.0.0 alpha

// · 
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~

=end

def seed_initial_users email, password

    User.find_or_create_by(email: email) do |user|
        user.password = password
        user.password_confirmation = password
        user.accounts_id = 1
        user.confirm

        user.account.user = user
        user.account.save!
    end

end

seed_initial_users "hello@lesli.cloud", "lesli2020"

if defined?(CloudHaus)
    seed_initial_users "crm.admin@deutsche-leibrenten.de", "crm.admin@deutsche-leibrenten.de"
end

p "Users successfully created!"
