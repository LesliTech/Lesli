/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
