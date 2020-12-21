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

    install (Vue, current_user, app) {

        
        let granted = function(module, action, base_path){
            let controller = `${base_path}_${module}`
            let privilege = current_user.abilities[controller]
            if (privilege){
                if (privilege[`grant_${action}`]) 
                    return true
            }
            return false
        }

        let privilege = function(module, base_path){
            let controller = base_path
            if(module){
                controller = `${controller}/${module}`
            }

            let privilege = current_user.abilities[controller]
            if (privilege) {
                return privilege
            }

            return {}
        }

        let isRole = function(...roles) {
            
            for(let index in current_user.roles){
                if(roles.includes(current_user.roles[index])) {
                    return true
                }
            }

            return false
        }

        Vue.prototype.abilities = {


            // return an object with privileges for the current controller
            privileges: function() {
                return current_user.abilities[app]
            },

            granted,
            privilege,
            isRole
            
        }

    }
    
}

