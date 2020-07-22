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

    install (Vue, current_user) {

        let granted = function(module, action, base_path = "cloud_haus"){
            let controller = `${base_path}_${module}`
            let privilege = lesli.current_user.privileges[controller]
            if (privilege){
                if (privilege[`grant_${action}`]) 
                    return true
            }
            return false
        }

        let privilege = function(module, base_path = "cloud_haus"){
            let controller = base_path
            if(module){
                controller = `${controller}/${module}`
            }

            let privilege = lesli.current_user.privileges[controller]
            if (privilege) {
                return privilege
            }
            return {}
        }

        let isRole = function(...roles) {
            return roles.includes(current_user.role)
        }

        Vue.prototype.abilities = {
            granted,
            privilege,
            isRole
        }

    }
    
}

