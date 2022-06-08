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
import { useUser } from "LesliVue/stores/user"


// · 
export const useManagementSessions = defineStore("managementSessions", {
    state: () => {
        const storeUser = useUser()
        return {
            storeUser: storeUser,
            loading: false,
            columns: [{
                field: 'id',
                label: 'ID'
            }, {
                field: 'user_agent',
                label: 'Device'
            }, {
                field: 'session_source',
                label: 'Source'
            }, {
                field: 'created_at_date',
                label: 'Created at'
            }, {
                field: 'last_used_at_string',
                label: 'Last used at'
            }],
            records: []
        }
    },

    actions: {

        fetch() {
            //if (this.storeUser.user.id) {
                this.fetchSessions()
            //}
        },

        fetchSessions() {

            this.loading = true

            this.http.get(this.url.admin("users/:id/sessions", 8 /*this.storeUser.user.id*/)).then(result => {                
                this.records = result.records
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        }
    }
})
