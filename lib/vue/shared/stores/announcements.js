/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
        closeAnnouncement(announcement){
            this.http.post(this.url.bell('announcements/:id/users', announcement.id)
            ).then(() => {
                announcement.status = 'closed'
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })

        }
    }
})
