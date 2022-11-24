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
import { defineStore } from "pinia"


// · 
export const useLayout = defineStore("core.layout", {
    state: () => {
        return {
            showEngines: false,
            showNotifications: false,
            showTasks: false,
            showFiles: false,
            showTickets: false,
            showAnnouncements: false,
            header: {
                notifications: lesli.notifications,
                tickets: lesli.tickets,
                tasks: lesli.tasks
            }
        }
    },
    actions: {
        toggleEngines() {
            this.showEngines = !this.showEngines
        }
    }
})
