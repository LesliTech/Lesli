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
            notifications: {
                pagination: {},
                records: []
            },
            passwords: {
                password: "",
                password_confirmation: ""
            },
            user: {
                email: null,
                roles_id: null,
                alias:  null,
                detail_attributes: {
                    first_name: null,
                    last_name: null,
                    telephone: null,
                    salutation: null,
                    title: null,
                }
            },
            options: {
                salutations: null,
                roles: [],
            }, 
            selectRoles: {}
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
        /**
         * @description This action is used to get users information
         * @param {String} id Id of the user, if not provided list all users
         */
        fetch(id=null) {
            this.loading = true

            // get the profile by default
            let url = this.url.admin("profile")

            // get an specifick user if id is provided
            if (id) url = this.url.admin("users/:id", id);

            this.http.get(url).then(result => {
                this.user = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })

        },

        /**
         * @description This action is used to fetch notifications
         */
        fetchNotifications() {
            this.http.get(this.url.profile("notifications")).then(result => {
                this.notifications = result
            })
        },

        /**
         * @description This action is used to update an existing user information
         */
        updateInformation() {
            this.http.put(this.url.admin("users/:id", this.user.id), {
                user: this.user
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to update an user's password
         */
        updatePassword() {
            this.http.put("/", {
                user: this.passwords
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to end the session of a user
         */
        doLogout() {
            this.http.put(this.url.admin("users/:id/logout", this.user.id)).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.getUsers()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to revoke access to a user
         */
        doRevokeAccess() {
            this.http.put(this.url.admin("users/:id/lock", this.user.id)).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.getUsers()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to create a new user
         */
        newUser(){
            this.http.post(this.url.admin("users"), {
                user: this.user
            }).then(result => {
                this.fetch()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to get options to display in the user information form
         */
        getOptions() {
            this.loading = true
            this.http.get(this.url.admin("users/options")).then(result => {
                this.options.salutations = result.salutations
                this.parseRoles(result.roles)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to parse the roles from options
         * @param {Object} roles_raw The roles fetched from options with its original format
         */
        parseRoles(roles_raw){
            roles_raw.forEach(role => {
                this.options.roles.push({label: role.name, value: role.id})
            })
            this.loading = false
        },
    }
})
