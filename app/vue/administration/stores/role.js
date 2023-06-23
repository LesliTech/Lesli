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
export const useRole = defineStore("administration.role", {
    state: () => {
        return {
            options: {},
            records: [],
            descriptors: [],
            descriptorsCustom: [],
            descriptorSearchString: '',
            role: {
                name: "",
                descriptors: []
            },
            pagination: {
                page: 1
            },
            index: { 
                pagination: {},
                records: []
            },
            loading: false,             
            order: {
                column: "id",
                direction: "desc"
            },
            search_string: "",
            role_activities: {}
        }
    },
    actions: {

        fetch() {
            this.loading = true
            this.http.get(this.url.admin("roles")
                .paginate(this.pagination.page)
                .order(this.order.column, this.order.direction)
                .search(this.search_string))
            .then(result => {
                this.index = result
                this.records = result.records.map(integrations => {
                    integrations.created_at = this.date.dateTime(integrations.created_at)
                    return integrations
                })
                this.loading = false
            })
        },

        paginateIndex(page) {
            this.pagination.page = page
            this.fetch()
        },

        fetchRole(id) {
            this.loading = true
            this.http.get(this.url.admin("roles/:id", id)).then(result => {
                this.role = result
                this.getDescriptors()
                this.loading = false
            })
        },

        postRole() {
            return this.http.post(this.url.admin("roles"), this.role)
        },

        putRole() {
            this.http.put(this.url.admin("roles/:id", this.role.id), this.role).then(result => {
                this.msg.success(I18n.t('core.roles.messages_success_role_successfully_updated'))
            })
        },

        searchDescriptors(string) {
            this.descriptorSearchString = string
            this.getDescriptors()
        },

        getDescriptors() {

            let url = this.url.admin("roles/:id/descriptors", this.role.id)

            if (this.descriptorSearchString != '') {
                url = url.search(this.descriptorSearchString)
            }

            this.http.get(url).then(descriptors => {

                // reset the list of descriptors
                this.descriptors = []
                this.descriptorsCustom = []

                // temporary container for the descriptor matrix
                let descriptorgrid = {}

                // convert list of descriptors from: controller/action to controller/actions (like a matrix)
                descriptors.forEach(descriptor => {

                    if (["list", "index", "show", "create", "update", "destroy"].includes(descriptor.action)) {

                        if (!descriptorgrid[descriptor.reference]) {
                            descriptorgrid[descriptor.reference] = {
                                id: descriptor.id,
                                name: descriptor.name,
                                reference: descriptor.reference,
                                controller: descriptor.controller,
                                index: null, 
                                show: null, 
                                create: null, 
                                update: null, 
                                destroy: null
                            }
                        }

                        // add the id of the descriptor that the action belongs to
                        descriptorgrid[descriptor.reference][descriptor.action] = {
                            id: descriptor.id,
                            active: descriptor.active
                        }

                        return;

                    }

                    this.descriptorsCustom.push(descriptor)

                })

                // return the arrys only
                this.descriptors = Object.values(descriptorgrid)

            })
        },

        updateDescriptor(descriptor) {

            // enable descriptor
            if (descriptor.active) {
                return this.postDescriptor(descriptor)
            }

            // disable descriptor
            this.deleteDescriptor(descriptor)
            
        },

        postDescriptor(descriptor) {
            this.http.post(this.url.admin("roles/:id/descriptors", this.role.id), {
                role_descriptor: {
                    id: descriptor.id
                }
            })
        },

        deleteDescriptor(descriptor) {
            this.http.delete(this.url.admin("roles/:id/descriptors/:descriptor_id", {
                id: this.role.id,
                descriptor_id: descriptor.id
            }))
        },

        getOptions() {
            this.http.get(this.url.admin("roles/options")).then(result => {
                
                this.options = result
            })
        }, 
        /**
         * @description This action is used to sort the results
         */
        sortIndex(column, direction) {
            this.order.column = column
            this.order.direction = direction
            this.fetch()
        },
        /**
         * @description This action is used to search
         * @param {string} search_string 
         */
        search(search_string) {
            this.search_string = search_string
            this.fetch()
        },
        /**
         * @description This action is used to delete a role
         * @param {Integer} role_id id of the role to be deleted 
         */
        deleteRole(role_id){            
            this.http.delete(this.url.admin('roles/:id', {id: role_id})).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.fetch()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to fetch activity logs from a role
         */
        fetchLogs(){
            this.loading = true
            this.http.get(this.url.admin('roles/:id/activities', {id: this.role.id})).then(result => {
                this.role_activities = result.activities             
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })     
        }
    }
})
