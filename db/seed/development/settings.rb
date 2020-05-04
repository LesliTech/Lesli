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

if defined? CloudHaus
    # Deutsche-leibrenten settings initialize
    account = Account.find(1)
    
    account.settings.find_by(name: "theme").update!(value: "deutsche-blue")
    account.settings.find_by(name: "theme_variation").update!(value: "standard")
    account.settings.find_by(name: "date_format").update!(value: "%d.%m.%Y")
    account.settings.find_by(name: "date_format_full").update!(value: "%a, %B %d, %Y")
    account.settings.find_by(name: "date_format_time").update!(value: "%d.%m.%Y %H:%M")
    account.settings.find_by(name: "time_format").update!(value: "%H:%M")
    account.settings.find_by(name: "time_zone").update!(value: "Europe/Berlin")
    account.settings.find_by(name: "start_week_on").update!(value: "monday")
    account.settings.find_by(name: "password_minimum_length").update!(value: "6")
    account.settings.find_by(name: "password_expiration_time_months").update!(value: "12")
    account.settings.find_by(name: "theme_variation").update!(value: "standard")
end

p "Settings successfully created!"
