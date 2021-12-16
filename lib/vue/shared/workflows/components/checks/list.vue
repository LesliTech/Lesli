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
export default {
    props: {
        workflowId: {
            required: true
        },

        engineNamespace: {
            required: true
        },
        statusesTranslationsPath: {
            required: true,
            type: String
        },
        checkSelected: {
            type: Boolean,
            default: false
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared'),
                checks: I18n.t('core.workflow/checks'),
                roles: I18n.t('core.roles')
            },
            main_route: '',
            loading: false,
            pagination: {
                current_page: 1,
                per_page: 15,
                range_before: 3,
                range_after: 3
            }
        }
    },

    mounted(){
        this.setMainRoute()
        this.setTranslations()
        this.getWorkflowChecks()
    },

    methods: {
        setMainRoute(){
            if(this.engineNamespace == '/'){
                this.main_route = `/workflows/${this.workflowId}/checks`
            }else{
                this.main_route = `/${this.engineNamespace}/workflows/${this.workflowId}/checks`
            }
        },

        setTranslations(){
            this.translations.statuses = I18n.t(this.statusesTranslationsPath)
        },

        getWorkflowChecks(){
            this.loading = true
            let url = `${this.main_route}.json`

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.data.checks.records = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showCheck(check){
            this.data.checks.active_tab = 2
            this.data.checks.selected_record_id = check.id
        }
    },

    computed: {
        checksPage(){
            if(this.data.checks.records.length <= this.pagination.per_page){
                return this.data.checks.records
            }

            let start = (this.pagination.current_page - 1) * this.pagination.per_page
            let end = this.pagination.current_page * this.pagination.per_page
            return this.data.checks.records.slice(start, end)
        }
    },

    watch: {
        'data.checks.reload'(){
            if(this.data.checks.reload){
                this.getWorkflowChecks()
                this.data.checks.reload = false
            }
        }
    }
}
</script>
<template>
    <div class="tab-content">
        <div class="columns">
            <div class="column is-12 has-text-right">
                <b-button @click="getWorkflowChecks" :disabled="loading">
                    <b-icon icon="sync" :class="{'fa-spin': loading}"></b-icon>
                    <span>{{translations.core.view_btn_reload}}</span>
                </b-button>
            </div>
        </div>
        <component-data-loading v-if="loading">
        </component-data-loading>
        <component-data-empty v-if="data.checks.records.length == 0 && !loading">
        </component-data-empty>
        <b-table :data="checksPage" @click="showCheck" hoverable v-if="!loading && data.checks.records.length > 0">
            <template slot-scope="props">
                <b-table-column field="name" :label="translations.checks.column_name">
                    <small>{{ props.row.name }}</small>
                </b-table-column>
                <b-table-column field="initial_status_name" :label="translations.checks.column_initial_status_id">
                    <small>{{
                        object_utils.translateEnum(translations.core, 'column_enum_status', props.row.initial_status_name, null) ||
                        object_utils.translateEnum(translations.statuses, 'column_enum_status', props.row.initial_status_name, null) ||
                        object_utils.translateEnum(translations.statuses, 'status', props.row.initial_status_name)
                    }}</small>
                </b-table-column>
                <b-table-column field="final_status_name" :label="translations.checks.column_final_status_id">
                    <small>{{
                        object_utils.translateEnum(translations.core, 'column_enum_status', props.row.final_status_name, null) ||
                        object_utils.translateEnum(translations.statuses, 'column_enum_status', props.row.final_status_name, null) ||
                        object_utils.translateEnum(translations.statuses, 'status', props.row.final_status_name)
                    }}</small>
                </b-table-column>
                <b-table-column field="role_name" :label="translations.checks.column_roles_id">
                    <small>{{ object_utils.translateEnum(translations.roles, 'column_enum_role', props.row.role_name) }}</small>
                </b-table-column>
                <b-table-column field="user_type" :label="translations.checks.column_user_type">
                    <small>{{ object_utils.translateEnum(translations.checks, 'column_enum_user_type', props.row.user_type) }}</small>
                </b-table-column>
                <b-table-column field="user_name" :label="translations.checks.column_users_id">
                    <small>{{ props.row.user_name }}</small>
                </b-table-column>
                <b-table-column class="has-text-centered">
                    <span v-if="props.row.active" class="has-text-success">
                        <span>{{translations.checks.view_text_active}}</span>
                        <b-icon icon="check-circle" type="is-success" size="is-small"></b-icon>
                    </span>
                    <span v-else class="has-text-grey">
                        <span>{{translations.checks.view_text_inactive}}</span>
                        <b-icon icon="check-circle" size="is-small"></b-icon>
                    </span>
                </b-table-column>
            </template>
        </b-table>
        <hr>
        <b-pagination
            :simple="false"
            :total="data.checks.records.length"
            :current.sync="pagination.current_page"
            :range-before="pagination.range_before"
            :range-after="pagination.range_after"
            :per-page="pagination.per_page"
            order="is-centered"
            icon-prev="chevron-left"
            icon-next="chevron-right"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
        >
        </b-pagination>
    </div>
</template>
