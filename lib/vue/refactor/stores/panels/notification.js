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
                this.notification["subject"] = ""
                this.notification["body"] = ""
                this.notification["channel"] = ""
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
