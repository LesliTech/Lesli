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
import { useRouter } from 'vue-router'
import dayjs from 'dayjs'


// · 
export const useAnnouncements = defineStore("core.panel.announcements", {
    state: () => {
        return {
            loading: false,
            loaded: false,
            announcement: { can_be_closed: true },
            announcements: {},
            router: useRouter()
        }
    },
    actions: {
        /**
         * @description This action is used to create a new announcement
         */
        postAnnouncement(){
            this.loading = true

            // Workaround to get the right url for the announcemets even if the url 
            // is changed outside the vue 3 router, after everything is running in vue3
            // we can use the router to get the path
            this.announcement.base_path = window.location.pathname

            this.http.post(this.url.bell("announcements"), {
                announcement: this.announcement
            }).then(() => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.getAnnouncements()
                this.announcement = {}
                this.loading = false
            })
        },
        /**
         * @description This action is used to get announcements
         */
        getAnnouncements(){ 
            this.announcements = {}           
            this.loading = true

            let url = this.url.bell('announcements').filter({ 
                base_path: [this.router.currentRoute.path]
            })

            this.http.get(url).then(result => {
                this.loading = false
                this.announcements = result.records 
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to clear the announcement from the panel
         */
        clearForm(){
            this.announcement = {
                name: '',
                can_be_closed: true,
                category:  'normal',
                status: true, 
                message: ''
            }
        },
        /**
         * @description This action is used to delete an announcement
         */
        deleteAnnouncement(announcement_id){
            let url = this.url.bell('announcements/:id', {id: announcement_id})
            this.http.delete(url).then(result => {
                this.announcements = this.announcements.filter(e => e.id !== announcement_id)
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to show the information of the announcement selected
         */
        showAnnouncement(announcement){ 
            announcement = this.announcements.find(e => e.id === announcement.id) 
            this.announcement = announcement
            this.announcement.start_at= dayjs(this.announcement.start_at).format('YYYY-MM-DD') //Change date format to show in date selector
            this.announcement.end_at= dayjs(this.announcement.end_at).format('YYYY-MM-DD')   //Change date format to show in date selector      
        },
        /**
         * @description This action is used to check if the announcement exists to create or update the announcement
         */
        formSubmit() {
            if (this.announcement.id) {
                this.putAnnouncement()
            } else {
                this.postAnnouncement()
            }
        },
        /**
         * @description This action is used to update an announcement
         */
        putAnnouncement() {
            this.loading = true
            this.http.put(this.url.bell("announcements/:id", { id: this.announcement.id }), {
                announcement: this.announcement
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
    }
})
