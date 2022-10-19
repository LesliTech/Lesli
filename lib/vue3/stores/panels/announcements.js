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
export const useAnnouncements = defineStore("core.panel.announcements", {
    state: () => {
        return {
            loading: false,
            loaded: false,
            announcement: {}
        }
    },
    actions: {
        /**
         * @description This action is used to create a new announcement
         */
        postAnnouncement(){
            this.loading = true
            this.http.post(this.url.bell("announcements"), {
                announcement: {
                    ...this.announcement,
                    message: JSON.stringify(this.announcement.msg)
                }
            }).then(() => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.announcement = {}
                this.loading = false
            })
        }
    }
})
