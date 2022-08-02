/*
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { useDate } from "../composables/date"

// · 
export default {

    install: (app, options) => {
        var settings = {
            "time_zone": "America/Guatemala",
            "start_week_on": "sunday",
            "formats": {
                "date": "%d.%m.%Y",
                "time": "%H:%M",
                "date_time": "%d.%m.%Y %H:%M",
                "date_words": "%A, %B %d, %Y",
                "date_time_words": "%A, %B %d, %Y, %H:%M"
            }
        }

        if (typeof lesli !== 'undefined') {
            settings = lesli.settings.datetime2
        }

        app.config.globalProperties.date = useDate(settings)
    }
    
}
