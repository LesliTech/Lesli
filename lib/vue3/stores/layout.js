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
            showFiles: false,
            header: {
                notifications: lesli.notifications
            },
            announcements: []
        }
    },
    actions: {
        toggleEngines() {
            this.showEngines = !this.showEngines
        },
        getAnnouncements() {
            // let url = this.url.bell('announcements/list').filters({
            //     base_path: this.$router.currentRoute.path,
            //     start_at: true,
            //     end_at: true,
            //     status: true
            // })
            this.http.get(this.url.bell('announcements/list')).then(result => {
                console.log("success")
            }).catch(error => {
                console.log(error)
            })

        }
    }
})
