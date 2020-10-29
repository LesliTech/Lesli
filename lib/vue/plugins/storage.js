/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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

