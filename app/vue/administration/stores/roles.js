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
export const useRoles = defineStore("administration.roles", {
    state: () => {
        return {
            list: [],
            index: {
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        fetchList() {
            if (!this.list.length > 0) {
                this.getList()
            }
        },

        // Get the list of role user is able to work with
        // according to object level permissions
        getList() {
            this.http.get(this.url.admin("roles/list")).then(result => {
                this.list = result

                // parse the list of roles to be used in select control
                /*
                this.listOptions = []
                this.listOptions = result.map(role => {
                    return {
                        label: role.name,
                        value: role.id
                    }
                })
                */
            })
        },

        fetchRoles() {
            if (!this.list.length > 0) {
                this.getRoles()
            }
        },

        // Get the list of role user is able to work with
        // according to object level permissions
        getRoles() {
            this.http.get(this.url.admin("roles")).then(result => {
                this.index = result
            })
        },
    }
})
