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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class Setting < ApplicationRecord
    belongs_to :account, foreign_key: 'accounts_id'

    def initialize
        # date & time formats
        self.find_or_create({ name: "date_format", value: "%Y.%m.%d", account: self })
        self.find_or_create({ name: "date_format_full", value: "%a, %B %d, %Y", account: self })
        self.find_or_create({ name: "date_time_format", value: "%Y.%m.%d %H:%M", account: self })
        self.find_or_create({ name: "theme", value: "deutsche-leibrenten", account: self })
        self.find_or_create({ name: "theme_variation", value: "standard", account: self })

        #Setting.create({ name: "theme", value: "lesli", account: self })
        #Setting.create({ name: "theme_variation", value: "light", account: self })
    end

end
