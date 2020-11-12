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

        Vue.prototype.msg = {
            info: (message) => {
                ToastProgrammatic.open({
                    queue: false,
                    duration: 5000,
                    position: "is-bottom-right",
                    message: message,
                    type: "is-info"
                })
            }
        }

    }

}
