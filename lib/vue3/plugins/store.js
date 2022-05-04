/*
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
*/

import { reactive } from "vue"
// · 
export default {

    install: (app, options) => {

        // · The data.global object is reserved and contains data to be used by global components like
        // ·    The global flag that shows and hides the support form in all views
        let default_data = {
            global: {
                showPanelViewerPdf: (n,u) => {},
                show_panel_notifications: false,
                show_panel_subscriptions: false,
                show_panel_announcement: false,
                show_panel_support: false,
                show_panel_engines: false,
                show_panel_tasks: false,
                cloud_bell_notifications: 0,
                cloud_bell_notification: {},
                search: "",
                
            }
        }

        // merge default data with specific data for module_app.js
        //data = { ...data, ...default_data }

        app.config.globalProperties.store = reactive({ name: "ldonis" })

    }

}
