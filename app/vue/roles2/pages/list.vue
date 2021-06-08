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
            roles: {},
            translations: {
                core: {
                    roles: I18n.t('core.roles'),
                    shared: I18n.t('core.shared'),
                }
            },
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
                this.msg.success(this.translations.core.roles.messages_success_role_successfully_updated)
            })
        },
        updateRole() {
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.roles.view_title_roles">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>{{ translations.core.shared.view_btn_list }}</span>
                </router-link>
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.core.roles.view_btn_new_role }}</span>
                </router-link>
            </div>
        </component-header>
        <component-toolbar></component-toolbar>
        <div class="box">
            <b-table
                hoverable
                :data="roles.records">
                <template slot-scope="props">
                    <b-table-column :label="translations.core.roles.column_id" width="50" :numeric="true" sortable centered>
                        <router-link :to="'/'+props.row.id">
                            {{ props.row.id }}
                        </router-link>
                    </b-table-column>
                    <b-table-column :label="translations.core.roles.column_name" sortable>
                        <router-link :to="'/'+props.row.id">
                            <u>{{ props.row.name }}</u>
                        </router-link>
                    </b-table-column>
                    <b-table-column :label="translations.core.roles.column_active" sortable>
                        <b-switch v-model="props.row.active" :true-value="true" :false-value="false" @input="updateRoleStatus(props.row)" type="is-success">
                        </b-switch>
                    </b-table-column>
                    <b-table-column :label="translations.core.roles.column_only_my_data" sortable>
                        <b-switch :value="props.row.only_my_data" type="is-success">
                        </b-switch>
                    </b-table-column>
                    <b-table-column :label="translations.core.roles.column_default_path" sortable centered>
                        {{ props.row.default_path }}
                    </b-table-column>
                    <b-table-column :label="translations.core.roles.view_table_header_users_count" sortable centered>
                        {{ props.row.user_count || 0 }}
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </section>
</template>
