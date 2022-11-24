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
        },

        /**
         * @description This action is used to change the user email
         */
        changeEmail(){
        this.dialog.confirmation({
            title: I18n.t("core.users/confirmations.view_text_new_email"),
            text: I18n.t("core.users/confirmations.view_text_change_email_confirmation_body"),
            confirmText: I18n.t("core.shared.view_text_yes"),
            cancelText: I18n.t("core.shared.view_text_no")
        })
        .then(({ isConfirmed }) => {
            if (isConfirmed && this.new_email!==null) {
                this.http.put(this.url.admin('users/:id/actions/email', this.profile.id), {
                    user: {
                        email: this.new_email
                    }
                }).then(result => {
                    this.msg.success(I18n.t("core.users.messages_success_operation"))
                }) .catch(error => {
                    this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
                })
            } else {
                this.user.email = ""
            }
        })
    }
    }
})
