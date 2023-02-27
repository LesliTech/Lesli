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
export const useAccountIssues = defineStore("administration.account.issues", {
    state: () => {
        return {
            options: {},
            records: [],
            pagination: {
                page: 1
            },
            index: { 
                pagination: {},
                records: []
            },
            loading: false          
        }
    },
    actions: {

        fetch() {
            this.loading = true
            this.http.get(this.url.admin("account/issues").paginate(this.pagination.page)).then(result => {
                this.index = result
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
    }
})
