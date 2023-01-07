/*
Copyright (c) 2023, all rights reserved.

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
            search_string: ""
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

            let url = this.url.admin("roles/:id/describers", this.role.id)

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

                    if (['index', 'show', 'new', 'edit', 'destroy', 'search'].includes(descriptor.action)) {

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
            this.http.post(this.url.admin("roles/:id/describers", this.role.id), {
                role_describer: {
                    id: descriptor.id
                }
            })
        },

        deleteDescriptor(descriptor) {
            this.http.delete(this.url.admin("roles/:id/describers/:descriptor_id", {
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
        }

    }
})
