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
export const useUsers = defineStore("users", {
    state: () => {
        return {
            loading: false,
            string: "",
            order: {
                column: "id",
                direction: "desc"
            },
            index: { 
                pagination: {},
                records: []
            }
        }
    },
    actions: {

        search(string) {
            this.string = string
            this.fetchIndex()
        },

        sortIndex(column, direction) {
            this.order.column = column
            this.order.direction = direction
            this.fetchIndex()
        },

        fetchIndex() {

            this.loading = true

            this.http.get(
                this.url
                .admin("users")
                .search(this.string)
                .order(this.order.column, this.order.direction)
            ).then(result => {
                this.index = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        }
    }
})
