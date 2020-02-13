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

module CloudHelper

    class Date

        def self.to_string(datetime, format="%Y/%m/%d %H:%M")
            datetime.strftime(datetime, format)
        end

        def self.full_to_string(datetime)
            datetime.strftime("%a, %B %d, %Y")
        end

        def self.to_string(datetime)
            datetime.strftime("%Y.%m.%d %H:%M")
        end

        def self.date_as_string(datetime)
            datetime.strftime("%Y.%m.%d")
        end

        def self.from_string(string, format="%Y.%m.%d %H:%M")
            Date.strptime(string, format)
        end

    end
end
