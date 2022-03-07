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
export default {

    install(Vue, options) {

        if(!options.cable) {

            return Vue.prototype.wss = {}

        }

        let channel = `notifications_${options.current_user.id}`

        channel = "ws://localhost:8080/wss?channel=".concat(channel)

        Vue.prototype.wss = new WebSocket(channel);
        
    }

}
