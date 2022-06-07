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


// · 
export const useUser = defineStore("user", {
    state: () => {
        return {
            loading: false,
            passwords: {
                password: "",
                password_confirmation: ""
            },
            user: {
                detail_attributes: {}
            }
        }
    },
    getters: {
        initials() {

            let initials = ""

            if (this.user?.detail_attributes?.first_name) {
                initials += this.user?.detail_attributes?.first_name[0]
            }

            if (this.user?.detail_attributes?.last_name) {
                initials += this.user?.detail_attributes?.last_name[0]
            }

            return initials.toUpperCase();

        }
    },
    actions: {

        fetch(id=null) {

            this.loading = true

            // get the profile by default
            let url = this.url.admin("profile")

            // get an specifick user if id is provided
            if (id) url = this.url.admin("users/:id", id);

            this.http.get(url)
            .then(result => {
                this.user = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        },

        updateInformation() {
            this.http.put(this.url.admin("users/:id", this.user.id), {
                user: this.user
            }).then(result => {
                console.log(result)
                //this.msg.success(this.translations.users.messages_success_user_updated)
            }).catch(error => {
                //this.msg.error(result.error.message)
            })
        },

        updatePassword() {
            this.http.put("/", {
                user: this.passwords
            }).then(result => {
                //this.msg.success(this.translations.passwords.notification_password_updated)
            }).catch(error => {
                //this.msg.error(result.error.message)
            })
        }

    }
})
