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
export const useDescriptor = defineStore("administration.descriptor", {
    state: () => {
        return {
            list: [],
            records: [],
            pagination: {},
            descriptor: {},
            loading: false,
            pagination: {
                page: 1
            },
            index: { 
                pagination: {},
                records: []
            },
            descriptors_options: []
        }
    },
    actions: {

        fetch(url=this.url.admin("descriptors")) {
            this.loading = true
            this.http.get(url).then(result => {
                this.index = result
                this.records = result.records.map(descriptor => {
                    descriptor.created_at = this.date.dateTime(descriptor.created_at)
                    descriptor.updated_at = this.date.dateTime(descriptor.updated_at)
                    return descriptor
                })
                this.loading = false
            })
        },

        fetchDescriptor(id) {
            this.http.get(this.url.admin("descriptors/:id", id)).then(result => {
                this.descriptor = result
                this.descriptor.privileges = this.descriptor.privileges.map(privilege => {
                    privilege.created_at = this.date.dateTime(privilege.created_at)
                    return privilege
                })
            })
        },

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
        */
        resetDescriptor(){
            this.descriptor = {}
        },
        /**
        * @description This action is used to create a descriptor
        */
        createDescriptor(){
            this.loading = true
            this.http.post(this.url.admin("descriptors"), { descriptor: this.descriptor }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })

        },
        /**
        * @description This action is used to update a descriptor
        */
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
        */
        sortIndex(column, direction) {
            this.fetch(this.url.admin("descriptors").order(column, direction))
        },
        /**
         * @description This action is used to search
         * @param {string} search_string
         */
        search(search_string) {
            this.fetch(this.url.admin("descriptors").search(search_string))
        },
        /**
         * @description This action is used to paginate index
         * @param {string} page actual page 
         */
        paginateIndex(page) {
            this.pagination.page = page
            this.fetch(this.url.admin("descriptors").paginate(this.pagination.page))
        },
        /**
        * @description This action is used to get descriptors as options
        */
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
        }

    }
})
