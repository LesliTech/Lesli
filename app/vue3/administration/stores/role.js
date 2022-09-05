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
export const useRole = defineStore("administration.role", {
    state: () => {
        return {
            options: {},
            records: [],
            pagination: {},
            descriptors: [],
            role: {
                name: "",
                descriptors: []
            }
        }
    },
    actions: {

        fetch() {
            this.http.get(this.url.admin("roles")).then(result => {
                this.pagination = result.pagination
                this.records = result.records.map(integrations => {
                    integrations.created_at = this.date.dateTime(integrations.created_at)
                    return integrations
                })
            })
        },

        fetchRole(id) {
            this.http.get(this.url.admin("roles/:id", id)).then(result => {
                this.role = result
                this.getDescriptors()
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

        getDescriptors() {
            this.http.get(this.url.admin("roles/:id/describers", this.role.id)).then(descriptors => {
                this.descriptors = descriptors
            })
        },

        changeDescriptor(descriptor) {

            if (descriptor.active) {
                return this.postDescriptor(descriptor)
            }

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
        }

    }
})
