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
import { useLayout } from "LesliVue/stores/layout"
import dayjs from 'dayjs'


// · 
export const useAnnouncements = defineStore("core.panel.announcements", {
    state: () => {
        return {
            loading: false,
            loaded: false,
            announcement: {
                name: '',
                can_be_closed: true,
                category:  'info',
                status: true, 
                message: ''
            },
            announcements: {},
            richText: {},
            storeLayout: useLayout()
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
                    message: JSON.stringify(this.announcement.message)
                }
            }).then(() => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.getAnnouncements()
                this.announcement = {}
                this.storeLayout.showAnnouncements = false
                this.loading = false
            })
        },
        /**
         * @description This action is used to get announcements
         */
        getAnnouncements(){ 
            this.announcements = {}           
            this.loading = true
            this.http.get(this.url.bell('announcements')).then(result => {
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
                category:  'info',
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
                announcement: { 
                    ...this.announcement,
                    message: JSON.stringify(this.announcement.msg)
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        }
    }
})
