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

model = User.new
model.email = 'admin@lesli.cloud'
model.password = 'lesli2019'
model.password_confirmation = 'lesli2019'
model.accounts_id = 1
model.confirm
model.save!

10.times do
    model = User.new
    model.email = Faker::Internet.email
    model.password = model.email
    model.password_confirmation = model.email
    model.confirm
    model.save!
end
