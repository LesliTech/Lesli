leslicloud_account


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

    install (Vue, current_path, current_user) {

        let save = function(data, global = false, storage_type = 'local'){
            let path = global ? globalPath() : `${current_path}_${current_user.id}`

            data = JSON.stringify(data)

            if (storage_type === 'local') {
                localStorage.setItem(path, data)
            } else {
                sessionStorage.setItem(path, data)
            }
        }

        let get = function(key = null, global = false, storage_type = 'local'){
            let path = global ? globalPath() : `${current_path}_${current_user.id}`
            
            let data = {}

            if (storage_type === 'local') {
                data = localStorage.getItem(path)
            } else {
                data = sessionStorage.getItem(path)
            }

            if (data !== 'undefined' && data) {
                data = JSON.parse(data)
                
                if (key) {
                    return data[key]
                }

                return data
            }

            return {}
        }

        let globalPath = function(){
            return 'lesli_app_storage'
        }

        Vue.prototype.storage = {
            save,
            get
        }

    }
    
}

