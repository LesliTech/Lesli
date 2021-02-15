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
            roles: {}
        }
    },
    mounted() {
        this.getRoles()
    },
    methods: {
        getRoles() {
            this.http.get(this.url.admin("roles").paginate(1)).then(result => {
                if (!result.successful) {
                    return
                }
                this.roles = result.data
            }).catch(error => {
                console.log(error)
            })
        },
        updateRoleStatus(role) {
            this.http.put(this.url.admin("roles/:id", { id: role.id }), {
                role: {
                    active: role.active
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.warn("Error")
                    return
                }
                this.msg.success("Role successfully updated")
            })
        },
        updateRole() {
            console.log("works")
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Roles">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>List</span>
                </router-link>
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span>New role</span>
                </router-link>
            </div>
        </component-header>
        <component-toolbar></component-toolbar>
        <div class="box">
            <b-table 
                hoverable
                :data="roles.records">
                <template slot-scope="props">
                    <b-table-column label="ID" width="50" :numeric="true" sortable centered>
                        <router-link :to="'/'+props.row.id">
                            {{ props.row.id }}
                        </router-link>
                    </b-table-column>
                    <b-table-column label="Name" sortable>
                        <router-link :to="'/'+props.row.id">
                            <u>{{ props.row.name }}</u>
                        </router-link>
                    </b-table-column>
                    <b-table-column label="Status" sortable>
                        <b-switch v-model="props.row.active" :true-value="true" :false-value="false" @input="updateRoleStatus(props.row)" type="is-success">
                        </b-switch>
                    </b-table-column>
                    <b-table-column label="Only own data" sortable>
                        <b-switch :value="props.row.only_my_data" type="is-success">
                        </b-switch>
                    </b-table-column>
                    <b-table-column label="Default path" sortable centered>
                        {{ props.row.default_path }}
                    </b-table-column>
                    <b-table-column label="Users" sortable centered>
                        {{ props.row.user_count || 0 }}
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </section>
</template>
