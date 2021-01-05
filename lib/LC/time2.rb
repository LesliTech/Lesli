
=begin
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

include ActionView::Helpers::DateHelper

module LC

    # IMPORTANT: This library must implement the same methods as the vue time plugin
    # Check the docs for more information: /development/docs/rails-lib-time
    class Time2
 
        # NOTE: Do not modify settings here,
        # if you need a different date format you should change it in the config file
        # Check the docs for more information: /development/docs/rails-lib-time
        @settings = {
            "date_format" => "%d.%m.%Y", 
            "date_format_full" => "%a, %B %d, %Y", 
            "date_format_time" => "%d.%m.%Y %H:%M", 
            "time_format" => "%H:%M", 
            "time_zone" => "Europe/Berlin", 
            "start_week_on" => "monday"
        }

    end

end
