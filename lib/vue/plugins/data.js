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


// · 
export default {

    install (Vue, data) {

        // · The data.global object is reserved and contains data to be used by global components like
        // ·    The global flag that shows and hides the support form in all views
        let default_data = {
            global: {
                show_support_sidebar: false,
                show_panel_notifications: false,
                show_panel_tasks: false,
                cloud_bell_notifications: 0,
                cloud_bell_notification: {},
            }
        }

        // merge default data with specific data for module_app.js
        data = {...data, ...default_data}

       Vue.prototype.data = Vue.observable(data)
       Vue.prototype.store = Vue.observable(data)

    }

}
