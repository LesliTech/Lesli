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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Luis Davila
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description testing seeders

=end
User.find_or_create_by(email: 'admin@lesli.cloud') do |user|
    user.password = 'lesli2019'
    user.password_confirmation = 'lesli2019'
    user.accounts_id = 1
    user.confirm

    user.account.user = user
    user.account.save!
end