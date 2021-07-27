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
            payload: {},
            table_columns: []
        }
    },
    mounted() {
        this.component.custom_configuration.columns.forEach(column => {
            this.table_columns.push({
                field: column,
                label: column.replace("_", " ")
            })
        })
        this.getPayload()
    },
    methods: {
        
        getPayload() {
            this.http.get(this.component.url)
            .then(result => {
                if (!result.successful) { return; }
                this.payload = result.data
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
                :data="payload.records" 
                :columns="table_columns">
            </b-table>
        </div>
    </div>
</template>
