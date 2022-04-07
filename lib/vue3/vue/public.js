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


// · Loading core framework and libraries
import { createApp } from "vue"



// · Loading app functions
import debug from "lesli-js/debug/browser"



// · module: Engine name
// · base_path: Engine mounth path 
// · apps: List of controllers apps loaded
// · routes: Array of routes for Vue 
// · data: Object for the state management 
// · example: app("CloudHelp", "/help", "[dashboard|tickets|catalogs|etc]", [], {})
export default (appbuilder) => {


    // · Building Vue cloud app
    let app = createApp(appbuilder)


    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        app.mount("#lesli-application")
        
        // · development message about vue app loaded
        if (lesli_app_mode_development) { 
            debug.info("Lesli application") 
        }

        // · console production message
        if (lesli_app_mode_production) { 
            console.clear()
            debug.lesli_message_warning(lesli?.company?.name?.replace("Cloud", "")) 
        }

    });

}
