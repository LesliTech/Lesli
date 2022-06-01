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
export const useUser = defineStore("user", {
    state: () => {
        return {
            loaded:false,
            loading: false,
            index: {
                pagination: {},
                records: []
            },
            list: [],
            user: {
                detail_attributes: {}
            }
        }
    },
    getters: {

        initials() {

            let initials = ""

            if (this.user?.detail_attributes?.first_name) {
                initials += this.user?.detail_attributes?.first_name[0]
            }

            if (this.user?.detail_attributes?.last_name) {
                initials += this.user?.detail_attributes?.last_name[0]
            }

            return initials.toUpperCase();

        }

    },

    actions: {

        fetch(id) {
            this.loading = true
            this.http.get(this.url.admin("users/:id", id)).then(result => {
                this.user = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        fetchList() {

        },

        sortIndex(column, direction) {
            this.fetchIndex(this.url.admin("users").order(column, direction), false)
        },

        fetchIndex(url=this.url.admin("users"), loading=true) {

            this.loading = loading

            this.http.get(url).then(result => {
                this.index = result
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        }
    }
})
