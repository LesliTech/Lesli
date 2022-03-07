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


// · Plugin initializing 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue, app_id, current_user) {

        var storage_local_key = app_id.concat("-").concat(current_user.id)

        var storageKey = key => storage_local_key.concat("-").concat(key)

        var storageKeyGlobal = key => "lesli-application".concat("-").concat(key)

        let local = (key, data=null) => {

            if (data) {
                localStorage.setItem(storageKey(key), JSON.stringify(data))
                return 
            }
            
            return JSON.parse(localStorage.getItem(storageKey(key)))

        }

        let session = (key, data=null) => {

            if (data) {
                sessionStorage.setItem(storageKey(key), JSON.stringify(data))
                return 
            }
            
            return JSON.parse(sessionStorage.getItem(storageKey(key)))

        }

        let global = (key, data=null) => {

            if (data) {
                localStorage.setItem(storageKeyGlobal(key), JSON.stringify(data))
                return 
            }
            
            return JSON.parse(localStorage.getItem(storageKeyGlobal(key)))

        }

        Vue.prototype.storage = {
            local,
            session,
            global
        }
    }
}

