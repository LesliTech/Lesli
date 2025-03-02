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
export const useNotifications = defineStore("lesli.panelBellNotifications", {
    state: () => {
        return {
            loading: false,
            notifications: {
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        get() {
            this.http.get(this.url.bell("notifications")).then(result => {
                this.notifications.pagination = result.pagination
                this.notifications.records = result.records
            }).catch(error => {
                console.log(error)
            })
        },

        read(id) {
            this.http.put(this.url.bell("notifications/:id", id)).then(result => {
                const index = this.notifications.records.findIndex(item => item.id === id);
                if (index !== -1) {
                    this.notifications.records.splice(index, 1); 
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
})
