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
import { useUser } from "LesliVue/stores/user"


// · 
export const useProfile = defineStore("profile", {
    state: () => {
        return {
            storeUser: useUser(),
            loading: false,
            profile: {
                detail_attributes: {}
            }
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

            this.http.get(this.url.admin("profile")).then(result => {                
                this.profile = result.data
                this.storeUser.fetch(this.profile.id)
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        }
    }
})
