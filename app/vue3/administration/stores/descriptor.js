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
            records: [],
            pagination: {},
            descriptor: {}
        }
    },
    actions: {

        fetch() {
            this.http.get(this.url.admin("descriptors")).then(result => {
                this.pagination = result.pagination
                this.records = result.records.map(descriptor => {
                    descriptor.created_at = this.date.dateTime(descriptor.created_at)
                    descriptor.updated_at = this.date.dateTime(descriptor.updated_at)
                    return descriptor
                })
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
        }

    }
})
