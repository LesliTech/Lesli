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
            sessions: [],
            columns_sessions: [{
                field: 'id',
                label: 'ID'
            }, {
                field: 'user_agent',
                label: 'Device'
            }, {
                field: 'session_source',
                label: 'Source'
            }, {
                field: 'created_at_date',
                label: 'Created at'
            }, {
                field: 'last_used_at_string',
                label: 'Last used at'
            }],
            options: {
                salutations: null,
                roles: [],
                engines: [],
                locales: []
            },
            current_user: {}, 
            subscriptions: {},
            language: null,
            roles: [],
            rolesToggle: {},
            rolesSelect: [],
            pagination: {
                page: 1
            },
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

            return initials.toUpperCase()

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
            if (id) { url = this.url.admin("users/:id", id) }

            this.http.get(url).then(result => {
                this.user = result
                this.user.password = ""
                this.user.password_confirmation = ""
                this.roles = []
                result.roles.forEach(role => {
                    this.roles.push(role.id)
                })
                this.language = result.language ? result.language.value : this.language
                this.parseRolesToggle()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })

        },

        /**
         * @description This action is used to set roles in toggle options
         */
        parseRolesToggle(){
            this.rolesToggle = {}
            this.options.roles.forEach(role =>{   
                if ((this.roles).includes(role.id)){
                    this.rolesToggle[role.id] = true
                } else{
                    this.rolesToggle[role.id] = false
                }
            })
        },

        /**
         * @description This action is used to get options to display in the user information form
         */
        getOptions() {
            this.loading = true
            this.http.get(this.url.admin("users/options")).then(result => {
                this.options.salutations = result.salutations
                this.options.locales =[]
                Object.keys(result.locales).forEach(key => {
                    this.options.locales.push({label: result.locales[key], value: key})
                })
                this.options.roles = result.roles
                this.rolesSelect = []
                result.roles.forEach(role => {
                    this.rolesSelect.push({label: role.name, value: role.id})
                })

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /*
         * @description This action is used to fetch notifications
         */
        fetchNotifications() {
            this.http.get(this.url.profile("notifications").paginate(this.pagination.page)).then(result => {
                this.notifications = result
            })
        },
        /*
         * @description This action is used to paginate notifications
         */
        paginateNotifications(page) {
            this.pagination.page = page
            this.fetchNotifications()
        },

        /**
         * @description This action is used to update the notification and mark it as read
         */
        putNotification(current) {

            this.http.put(this.url.profile("notifications/:id", current.id)).then(result => {

                let position = this.notifications.records.map(notification => notification.id).indexOf(current.id)

                this.notifications.records.splice(position, 1)

                this.notifications.pagination.total--

            }).finally(() => {
                if (current.url) {
                    this.url.go(current.url)
                }
                this.fetchNotifications()
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

        /**
         * @description This action is used to end the session of a user
         */
        doLogout() {
            this.http.post(this.url.admin("users/:id/logout", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to revoke access to a user
         */
        doRevokeAccess() {
            this.http.post(this.url.admin("users/:id/lock", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        
        /**
         * @description This action is used to get sessions from a user
         */
        fetchSessions() {
            this.loading = true
            this.http.get(this.url.admin("users/:id/sessions", this.user.id )).then(result => {                
                this.sessions = result.records
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to set a new role to the user
         * @param {Object} role role to be assigned to the user
         */
        addUserRole(role) {
            this.dialog.confirmation({
                title: "Add role",
                text: 'Are you sure you want to set '+ role.name +' role to this user?',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.post(this.url.admin('users/:user_id/roles', {user_id: this.user.id}), {
                        user_role: {
                            id: role.id
                        }
                    }).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                } else{
                    this.rolesToggle[role.id] = false
                }
            })
        },

        /**
         * @description This action is used to delete a role from the user
         * @param {Object} role role to be deleted from the user
         */
        deleteUserRole(role) {
            this.dialog.confirmation({
                title: "Add role",
                text: 'Are you sure you want to revoke '+ role.name +' role to this user?',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin('users/:user_id/roles/:role_id', {user_id: this.user.id, role_id: role.id}))
                    .then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                } else{
                    this.rolesToggle[role.id] = true
                }
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
         * @description This action is used to get engine subscriptions options
         */
        getSubscriptionsOptions (){
            this.http.get(this.url.profile('subscriptions/options')).then(result => {
                result.engines.forEach(option => {
                    this.options.engines.push({label: option.text, value: option.value})
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to get subscriptions from a user
         * @param {String} engineSubscriptions The engine from which subscriptions are obtained
         */
        getSubscriptions(engineSubscriptions) {
            this.http.get(this.url.profile('subscriptions').filter({ engine: [engineSubscriptions]})).then(result => {
                this.subscriptions = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to reset values from user
         */
        resetUserStore(){
            this.user = {                
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
            }
        },

        /**
         * @description This action is used to change preferred language for a user
         */
        setLanguage(){
            this.dialog.confirmation({
                    title: "Change language",
                    text: "Are you sure you want to change the default language?",
                    confirmText: I18n.t("core.shared.view_text_yes"),
                    cancelText: I18n.t("core.shared.view_text_no")
                })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.post(this.url.admin('users/:id/settings', this.user.id), {
                        user_setting: {
                            name: 'locale', 
                            value: this.language
                        }
                    }).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
                    })
                }
            })
        },

        /**
         * @description This action is used to change the user status active or inactive
         */
        changeUserStatus(){
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
        /**
         * @description This action is used to delete a user
         */
        markUserAsDeleted() {
            this.dialog.confirmation({
                title: "Delete user",
                text: 'Are you sure you want to marked this user as deleted?',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("/users/:user_id", {
                        user_id: this.user.id
                    })).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                        this.url.go("/administration/users")
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
                    })
                }
            })
        },
        /**
         * @description This action is used to request password change from a user
         */
        doRequestPasswordChange() {
            this.http.post(this.url.admin("users/:id/resources/password", this.user.id)).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to close a session
         */
        closeSession(user_session_id){
            this.dialog.confirmation({
                title: "Close session",
                text: 'Are you sure you want to close this session',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("users/:id/sessions/:session_id", { id: this.user.id, session_id: user_session_id})).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                    this.fetchSessions()
                }
            })
        },

    }
})
