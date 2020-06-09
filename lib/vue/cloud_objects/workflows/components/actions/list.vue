<script>
export default {
    props: {
        workflowId: {
            required: true
        },

        cloudEngine: {
            required: true
        },
        translationsPath: {
            required: true,
            type: String
        },
        statusesTranslationsPath: {
            required: true,
            type: String
        },
        actionSelected: {
            type: Boolean,
            default: false
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            main_route: '',
            actions: [],
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
        this.getWorkflowActions()
        this.setSubscriptions()
    },

    methods: {
        setMainRoute(){
            this.main_route = `/${this.cloudEngine}/workflows/${this.workflowId}/actions`
        },

        setTranslations(){
            this.translations.main = I18n.t(this.translationsPath)
            this.translations.statuses = I18n.t(this.statusesTranslationsPath)
        },

        getWorkflowActions(){
            this.loading = true
            let url = `${this.main_route}.json`

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.actions = result.data
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showAction(action){
            this.$emit('update:action-selected', true)
            this.bus.publish('show:/module/workflow/action/edit', action)
        },

        setSubscriptions(){
            this.bus.subscribe('post:/module/workflow/action', ()=>{
                this.$emit('update:action-selected', true)
                this.getWorkflowActions()
            })

            
            this.bus.subscribe('destroy:/module/workflow/action', (deleted_action)=>{
            this.$emit('update:action-selected', false)
                this.actions = this.actions.filter(action => action.id != deleted_action.id)
            })
        }
    },

    beforeDestroy(){
        this.bus.$off('post:/module/workflow/action')
        this.bus.$off('destroy:/module/workflow/action')
    },

    computed: {
        actionsPage(){
            if(this.actions.length <= this.pagination.per_page){
                return this.actions
            }

            let start = (this.pagination.current_page - 1) * this.pagination.per_page
            let end = this.pagination.current_page * this.pagination.per_page
            return this.actions.slice(start, end)
        }
    }
}
</script>
<template>
    <div class="tab-content">
        <component-data-empty v-if="loading">
        </component-data-empty>
        <component-data-empty v-if="actions.length == 0 && !loading">
        </component-data-empty>
        <b-table :data="actionsPage" @click="showAction" hoverable v-if="!loading && actions.length > 0">
            <template slot-scope="props">
                <b-table-column field="name" :label="translations.core.text_name">
                    <small>{{ props.row.name }}</small>
                </b-table-column>
                <b-table-column field="action_type" :label="translations.core.text_type">
                    <small>{{ object_utils.translateEnum(translations.main, 'enum_action_type', props.row.action_type) }}</small>
                </b-table-column>
                <b-table-column field="initial_status_name" :label="translations.main.field_initial_status">
                    <small>
                        {{ object_utils.translateEnum(translations.statuses, 'status', props.row.initial_status_name) }}
                    </small>
                </b-table-column>
                <b-table-column field="final_status_name" :label="translations.main.field_final_status">
                    <small>
                        {{ object_utils.translateEnum(translations.statuses, 'status', props.row.final_status_name) }}
                    </small>
                </b-table-column>
            </template>
        </b-table>
        <hr>
        <b-pagination
            :simple="false"
            :total="actions.length"
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
