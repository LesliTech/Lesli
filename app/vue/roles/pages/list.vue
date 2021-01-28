<script>
/*
Copyright (c) 2020, all rights reserved.

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
export default {
    data() {
        return {
            roles: []
        }
    },
    mounted() {
        this.getRoles()
    },
    methods: {
        getRoles() {
            this.http.get("/administration/roles.json").then(result => {
                if (!result.successful) {
                    return
                }
                this.roles = result.data
            }).catch(error => {
                console.log(error)
            })
        },
        showRole(role) {
            this.$router.push(`${role.id}`)
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Roles"></component-header>
        <component-toolbar></component-toolbar>
        <b-table 
            hoverable
            :data="roles" 
            @click="showRole">
            <template slot-scope="props">
                <b-table-column label="ID" width="50" :numeric="true" sortable centered>
                    {{ props.row.id }}
                </b-table-column>
                <b-table-column label="Name" sortable>
                    {{ props.row.name }}
                </b-table-column>
                <b-table-column label="Status" sortable>
                    <b-switch :value="props.row.active" type="is-success">
                    </b-switch>
                </b-table-column>
                <b-table-column label="Only own data" sortable>
                    <b-switch :value="props.row.only_my_data" type="is-success">
                    </b-switch>
                </b-table-column>
                <b-table-column label="Default path" sortable centered>
                    {{ props.row.default_path }}
                </b-table-column>
                <b-table-column label="Level permission" sortable>
                    {{ props.row.object_level_permission }}
                </b-table-column>
                <b-table-column label="Users" sortable centered>
                    {{ props.row.user_count || 0 }}
                </b-table-column>
            </template>
        </b-table>
    </section>
</template>
