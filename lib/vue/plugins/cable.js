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

import { createConsumer } from "@rails/actioncable"

export default {

    install(Vue, options) {

        if(!options.cable) {
            return 
        }

        let consumer = createConsumer(Vue.prototype.url.to("cable").toString().replace("http", "ws"))

        let channel = consumer.subscriptions.create("WebNotificationsChannel", { 

            connected() {

            },

            disconnected() {
            
            },

            received(data) {
                console.log(data, JSON.stringify(data))
                Vue.prototype.store.global.cloud_bell_notification = data.notification
                Vue.prototype.store.global.cloud_bell_notifications = data.notifications
            }

        })
        
    }

}
