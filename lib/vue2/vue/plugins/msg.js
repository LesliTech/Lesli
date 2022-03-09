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
import sweetalert from 'sweetalert';


// · 
export default {

    install (Vue) {

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
            },

            dialog: {

                info: (title, message='') => {

                    return sweetalert(title, message, "info", {
                        button: "Aceptar",
                    })

                },

                success: (title, message='') => {

                    return sweetalert(title, message, "success", {
                        button: "Aceptar",
                    })

                },

                warning: (title, message='') => {

                    return sweetalert(title, message, 'warning', {
                        buttons: true,
                        dangerMode: true 
                    })

                },

                error: (title, message='') => {

                    return sweetalert(title, message, 'error', {
                        buttons: true,
                        dangerMode: true 
                    })

                }
            },

        }

    }

}
