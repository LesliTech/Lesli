/*
Copyright (c) 2020, all rights reserved.

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
import { ToastProgrammatic } from "buefy"



// · 
export default {

    install (Vue) {

        function prepareDesktopNotification() {

            if (!("Notification" in window)) {
                console.log("This browser does not support desktop notification");
                return
            }

            // Let's check whether notification permissions have already been granted
            if (Notification.permission === "granted") {
                // If it's okay let's create a notification
                return
            }

            // Otherwise, we need to ask the user for permission
            if (Notification.permission !== "denied") {
                Notification.requestPermission().then(function (permission) {
                    console.log(permission)
                })
            }

        }


        function push(subject, body, url) {

            prepareDesktopNotification()

            new Notification(subject, {
                //lang: I18n.locale,
                body: body
            });

        }


        function msg(message, duration=4000, type="is-white") {

            if (typeof(message) == "string") {

                message= [ message ]

            }

            message.forEach(message => {
                ToastProgrammatic.open({
                    queue: false,
                    position: "is-bottom-right",
                    duration: duration,
                    message: message,
                    type: type
                })    
            })            
            
        }

        Vue.prototype.msg = {

            push: (subject, body) => {
                
                push(subject, body)

            },

            // Simple message
            msg: (message) => {
                msg(message, 5000)
            },

            // Informative message
            info: (message) => {
                msg(message, 5000, "is-info")
            },

            // Warning message
            warn: (message) => {
                msg(message, 5000, "is-warning")
            },

            // Error message
            error: (message) => {
                msg(message, 6000, "is-danger")
            },

            // Success message
            success: (message) => {
                msg(message, 6000, "is-success")
            }

        }

    }

}
