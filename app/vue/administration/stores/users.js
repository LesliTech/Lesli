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

// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}

// · 
export const useUsers = defineStore("administration.users", {
    state: () => {
        return {
            loading: false,
            search: "",
            list: [],
            order: {
                column: "id",
                direction: "desc"
            },
            index: { 
                pagination: {},
                records: []
            },
            filters :{
                per_page: 10,
                role: null,
                status: 'active'
            },
            roles_options: [],

            user: {
                roles_id: null,
                email: null,
                first_name: null,
                last_name: null,
                telephone: null,
            }
        }
    },
    actions: {

        search(search_string) {
            this.index.pagination.page = 1
            this.search_string = search_string
            this.loading = true
            this.getUsers()
        },

        paginateIndex(page) {
            this.index.pagination.page = page
            this.getUsers()
        },

        sortIndex(column, direction) {
            this.order.column = column
            this.order.direction = direction
            this.getUsers()
        },

        fetchUsers() {

            if (!this.index.pagination?.results > 0) {
                this.loading = true
                this.getUsers()
            }

        },

        getUsers() {
            
            const query_filters = {}

            //Format filters to send them in the query string
            for (const [key, value] of Object.entries(this.filters)) {
                //query_filters[key] = [value]
            }

            this.http.get(
                this.url
                .admin("users")
                .search(this.search_string)
                .paginate(this.index.pagination.page, this.filters.per_page)
                .filter(query_filters)
                .order(this.order.column, this.order.direction)
            ).then(result => {
                this.index = result
                this.search_string=""
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },


        postUsers() {
            return this.http.post(this.url.admin("users"), {
                user: this.user
            })
        },


        /*
        doLogout(userId) {
            this.http.post(this.url.admin("users/:id/logout", userId).toString())
            .then(result => {
                this.msg.success(translations.core.users.messages_success_operation)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        doLock(userId) {
            this.http.post(this.url.admin("users/:id/lock", userId).toString())
            .then(result => {
                this.fetchIndex()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        translateEnum(value, translations, enum_prefix){
            const new_value = translations[`${enum_prefix}_${value}`]
            if(new_value){
                return new_value
            }

            return value
        },

        getRoles(){
            this.roles_options = [{label: I18n.t("core.users").view_toolbar_filter_all_roles, value: null}]
            this.http.get(this.url.admin('roles/list')).then(result => {
                result.forEach((option)=>{
                    const name = this.translateEnum(option.name, I18n.t("core.roles"), 'column_enum_role')
                    this.roles_options.push({
                        label: name,
                        value: option.id
                    })
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        fetchList() {
            this.loading = true
            return this.http.get(this.url.admin("users/list")).then(response => {
                //this.records = response
                this.list = response
            }).catch(error => {
                
            }).finally(() => {
                this.loading = false
            })
        }
        */
    }
})
