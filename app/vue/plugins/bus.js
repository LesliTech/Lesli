/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//  · 
*/



// · Loading core framework and libraries
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import { createConsumer } from "@rails/actioncable"



//  · Plugin initializing 
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue, options) {
    
        Vue.prototype.bus = new Vue()

        document.addEventListener("keydown", e => {

            if ((window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)  && e.keyCode == 83) {
                e.preventDefault()
                Vue.prototype.bus.$emit("cloud-ctrl-save")
            }

        }, false)

        Vue.prototype.notification = (message, type) => {
            Vue.prototype.bus.$emit('cloud/layout/notify/notification', message, type)
        }

        Vue.prototype.alert = (message, type) => {
            Vue.prototype.bus.$emit('cloud/layout/notify/alert', message, type)
        }

        let cable = createConsumer('/courier/cable')
        cable.subscriptions.create("CloudCourier::Bell::WebNotificationChannel", {
            received(data) {
                Vue.prototype.bus.$emit('cloud/layout/notify/notification#get')
                console.log(data)
            }
        })

    }
    
}
