<script>
/*

Copyright (c) 2021, all rights reserved.

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



export default {
    props: {
        component: Object
    },
    data() {
        return {
            sessions: {}
        }
    },
    mounted() {
        this.getSessions()
    },
    methods: {

        getSessions() {
            this.http.get(this.url.admin("users/:user_id/sessions", { user_id: lesli.current_user.id }))
            .then(result => {
                if (!result.successful) { return; }
                this.sessions = result.data
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3 class="card-header-title">{{ component.name }}</h3>
        </div>
        <div class="card-content">
            <b-table 
                :data="sessions.records" 
                :columns="[
                    { field:'user_agent', label: 'devise'},
                    { field:'created_at_date', label: 'date'},
                ]">
            </b-table>
        </div>
    </div>
</template>
