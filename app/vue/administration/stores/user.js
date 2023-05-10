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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useUser = defineStore("administration.user", {
    state: () => {
        return {
            options: {
                regions: [],
                locales: [],
                salutations: [],
                mfa_methods: []
            },
            user: {
                roles_id: null,
                email: null,
                alias: null,
                first_name: null,
                last_name: null,
                telephone: null,
                detail_attributes: {
                    salutation: null,
                    title: null,
                }
            },
            roles: [],
            sessions: {
                pagination: {},
                records: []
            },
            options: {
                salutations: [],
                locales: []
            }
        }
    },
    getters: {
        initials() {
            let initials = ""
            if (this.user?.first_name) initials += this.user?.first_name[0];
            if (this.user?.last_name) initials += this.user?.last_name[0];
            return initials.toUpperCase()
        }
    },
    actions: {

        getOptions() {
            this.http.get(this.url.admin("users/options")).then(result => {
                this.options = result
            })
        },

        getUser(id=null) {

            // get the profile by default
            let url = this.url.admin("profile")

            // get an specifick user if id is provided
            if (id) { url = this.url.admin("users/:id", id) }

            this.http.get(url).then(result => {
                this.user = result
                this.user.password = ""
                this.user.password_confirmation = ""

                this.language = result.locale ? result.locale.value : this.language

                this.role_names = result.roles.map(role => role.name).join(", ")
                
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        deleteUser() {
            this.dialog.confirmation({
                title: "Delete user",
                text: "Are you sure you want to delete user?",
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("/users/:id", this.user.id)).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                        //this.url.go("/administration/users")
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
                    })
                }
            })
        },

        getRoles() {
            this.http.get(this.url.admin("users/:id/roles", this.user.id)).then(result => {
                this.roles = result
            }).catch(error => {
                console.log(error)
            })
        },

        postRole(role) {
            this.http.post(this.url.admin('users/:id/roles', this.user.id), {
                user_role: {
                    id: role.id
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        deleteRole(role) {
            this.http.delete(this.url.admin('users/:user_id/roles/:role_id', {
                user_id: this.user.id, 
                role_id: role.id
            })).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        doRequestPassword() {
            this.http.post(this.url.admin("users/:id/requestpassword", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        doPasswordReset() {
            this.http.post(this.url.admin("users/:id/passwordreset", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        doLogout() {
            this.http.post(this.url.admin("users/:id/logout", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        doRevokeAccess() {
            this.http.post(this.url.admin("users/:id/revokeaccess", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        fetchSessions() {
            if (!this.sessions.length > 0) {
                this.getSessions()
            }
        },
        
        getSessions() {
            this.http.get(this.url.admin("users/:id/sessions", this.user.id )).then(result => {                
                this.sessions.pagination = result.pagination
                this.sessions.records = result.records
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        deleteSession(user_session_id){
            this.dialog.confirmation({
                title: "Close session",
                text: 'Are you sure you want to close this session',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("users/:id/sessions/:session_id", { 
                        id: this.user.id, 
                        session_id: user_session_id
                    })).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                    this.fetchSessions()
                }
            })
        },

        postLanguage() {
            this.http.post(this.url.admin('users/:id/settings', this.user.id), {
                user_setting: {
                    name: 'locale', 
                    value: this.user.locale.value
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                // TODO: Only if current_user changed his own language
                // reload the page so the user can work with the new language
                // setTimeout(() => window.location.reload(), 1000)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
            })
        },

        getOptions() {
            this.http.get(this.url.admin("users/options")).then(result => {
                this.options.salutations = result.salutations
        
                this.options.locales = Object.keys(result.locales).map(key => {
                    return {label: result.locales[key], value: key}
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
    }
})




/*







putUser() {
    this.http.put(this.url.admin("users/:id", this.user.id), {
        user: this.user
    }).then(result => {
        this.msg.success(I18n.t("core.users.messages_success_operation"))
    }).catch(error => {
        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
    })
},


updatePassword() {
    this.http.put("/", {
        user: {
            password: this.user.password,
            password_confirmation: this.user.password_confirmation
        }
    }).then(result => {
        this.msg.success(I18n.t("core.users.messages_success_operation"))
        this.user.password = ""
        this.user.password_confirmation = ""
    }).catch(error => {
        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
    })
},



//  This action is used to change the user status active or inactive
putUserStatus(){
    this.dialog.confirmation({
        title: "Change status",
        text: "Are you sure you want to change the status of this user?",
        confirmText: "Yes",
        cancelText: "No"
    })
    .then(({ isConfirmed }) => {
        if (isConfirmed) {
            this.http.patch(this.url.admin('users/:id', this.user.id), {
                user: {
                    active: this.user.active
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }) .catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
            })
        } else {
            this.user.active = !this.user.active
        }
    })
},


*/
