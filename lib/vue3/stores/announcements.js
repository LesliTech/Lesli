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
import { useRouter, useRoute } from 'vue-router'


// · 
export const useAnnouncements = defineStore("core.announcements", {
    state: () => {
        return {
            announcements: [],
            router: useRouter()
        }
    },
    actions: {
        /**
         * @description This action is used to get all the announcements available for the user
         */
        getAnnouncements() {
            this.http.get(this.url.bell('announcements/list').filter({ base_path: [this.router.currentRoute.path]})
            ).then(result => {
                this.announcements = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post a new registration that the announcement has been closed by this user
         * @param {String} announcement announcement to be closed
         */
        closeAnnouncement(announcement_id){
            this.http.post(this.url.bell('announcements/:id/users', announcement_id)
            ).then(() => {
                this.getAnnouncements()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })

        }
    }
})
