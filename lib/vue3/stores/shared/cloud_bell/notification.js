/*
Copyright (c) 2023, all rights reserved.

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

// · This store is needed to make http requests, manage the reactivity
// · of a workflow.

import { defineStore } from "pinia"

export const useNotification = defineStore("core.shared.bell.notification", {
    state: () => {
        return {
            loading: false,
            notification: {
                subject: "",
                body: "",
                channel: "",
                user_receiver_id: ""
            },
            options: {
                categories: [],
                channels: [],
            }
        }
    },
    actions: {
        /**
         * @description This action is used to send a Notification
         */
        sendNotification(){
            this.loading = true

            this.http.post(this.url.bell("notifications"), {
                notification: this.notification
            }).then(() => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
                this.notification = {
                    subject: "",
                    body: "",
                    channel: "",
                    user_receiver_id: ""
                }
            })

        },

        /**
         * @description This action is used to get options for notifications
         */
        getOptions(){
            this.options = {
                categories: [],
                channels: [],
            }

            this.loading = true

            this.http.get(this.url.bell("notifications/options")).then(result => {

                result["categories"].forEach((category)=>{
                    this.options["categories"].push({
                        label: category.text,
                        value: category.value
                    })
                })

                result["channels"].forEach((channel)=>{
                    this.options["channels"].push({
                        label: channel.text,
                        value: channel.value
                    })
                })

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },


    }
})
