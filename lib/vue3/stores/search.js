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
import { reactive } from "vue"


// · 
export const useSearch = defineStore("search", {
    state: () => {
        return {
            text: "",
            timer: null,
            loading: false,
            showResults: false,

            pagination: {},
            columns: [],
            records: []
        }
    },
    actions: {

        doSearch() {

            if (this.text == "") {
                this.showResults = false
                return 
            }

            this.loading = true

            clearTimeout(this.timer)

            this.timer = setTimeout(() => this.fetchSearch(), 800)

        }, 

        fetchSearch() {
            this.loading = true
            this.http("/search.json").then(result => {
                this.pagination = result.pagination
                this.columns = result.columns
                this.records = result.records
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        }

    }
})
