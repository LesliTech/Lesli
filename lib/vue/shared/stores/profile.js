/*
Copyright (c) 2022, all rights reserved.

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
import { defineStore } from "pinia"
import { useUser } from "LesliApp/administration/stores/user"
import { useUtils } from "Lesli/composables/utils"


const storeUtils = useUtils()


// · 
export const useProfile = defineStore("profile", {
    state: () => {
        return {
            storeUser: useUser(),
            loading: false,
            profile: {
                detail_attributes: {}
            },
            roles: [],
            new_email: null
        }
    },
    actions: {

        fetch() {
            if (!this.profile.id) {
                this.fetchProfile()
            }
        },

        fetchProfile() {
            this.loading = true
            this.roles = []
            this.http.get(this.url.admin("profile")).then(result => {                
                this.profile = result
                this.profile['initials'] = storeUtils.initials(
                    this.profile.first_name,
                    this.profile.last_name
                )
                this.parseRoles(result.roles)
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        },
        parseRoles(roles){
            this.roles = []
            roles.forEach(role =>{
                this.roles.push(role.name)
            })
        }
    }
})
