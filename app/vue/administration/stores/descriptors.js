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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useDescriptors = defineStore("administration.descriptors", {
    state: () => {
        return {
            list: [],
            descriptor: {},
            index: { 
                loading: false,
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        fetchDescriptors() {
            if (this.index.records.length > 0) {
                return 
            }

            this.getDescriptors()
        },

        getDescriptors() {
            this.index.loading = true
            this.http.get(this.url.admin("descriptors")).then(result => {
                this.index.pagination = result.pagination
                this.index.records = result.records
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.index.loading = false
            })
        },

        postDescriptor() {
            this.loading = true
            this.http.post(this.url.admin("descriptors"), { descriptor: this.descriptor }).then(result => {
                this.descriptor.id = result.id
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        resetDescriptor() {
            this.descriptor = {}
            this.privileges = []
        },

        /*
        fetchDescriptorList() {
            this.http.get(this.url.admin("descriptors/list")).then(result => {
                this.list = result.map(descriptor => {
                    descriptor.active = false
                    return descriptor
                })
            })
        },

        /**
        * @description This action is used to reset descriptor object
        * /
        
        
        /**
        * @description This action is used to create a descriptor
        * /
        
        
        /**
        * @description This action is used to update a descriptor
        * /
        updateDescriptor(){
            this.loading = true
            this.http.put(this.url.admin("descriptors/:id", this.descriptor.id), { descriptor: this.descriptor }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })

        },
        /**
        * @description This action is used to sort the results
        * /
        sortIndex(column, direction) {
            this.fetch(this.url.admin("descriptors").order(column, direction))
        },
        /**
         * @description This action is used to search
         * @param {string} search_string
         * /
        search(search_string) {
            this.fetch(this.url.admin("descriptors").search(search_string))
        },
        /**
         * @description This action is used to paginate index
         * @param {string} page actual page 
         * /
        paginateIndex(page) {
            this.pagination.page = page
            this.fetch(this.url.admin("descriptors").paginate(this.pagination.page))
        },
        /**
        * @description This action is used to get descriptors as options
        * /
        getDescriptorsOptions(){
            this.loading = true
            this.descriptors_options = []
            this.http.get(this.url.admin("descriptors/list")).then(result => {
                result.forEach((descriptor)=>{
                    this.descriptors_options.push({
                        label: descriptor.name,
                        value: descriptor.id
                    })
                })
                
                this.loading = false
            })
        },
        */
    }
})
