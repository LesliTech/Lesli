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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Plugin initializing 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue) {

        let granted = function(module, action, base_path = "cloud_haus"){
            let controller = `${base_path}_${module}`
            let privilege = leslicloud_account.account.privileges.find(e => grant_object_name === controller)
            if (privilege){
                if (privilege[`grant_${action}`]) 
                    return true
            }
            return false
        }

        let privilege = function(module, base_path = "cloud_haus"){
            let controller = `${base_path}/${module}`
            let privilege = leslicloud_account.user.privileges.find(e => e.grant_object_name === controller)
            if (privilege){
                return privilege
            }
            return {}
        }

        Vue.prototype.abilities = {
            granted,
            privilege
        }

    }
    
}

