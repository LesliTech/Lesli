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
        }
    },

    data(){
        return {
            show: false,
            translations: {
                core: I18n.t('core.shared')
            },
            main_route: '',
            actions: [],
            active_tab: 0,
            loading: false
        }
    },

    mounted(){
        this.setMainRoute()
        this.setSubscriptions()
        this.setTranslations()
        this.getWorkflowActions()
    },

    methods: {
        setMainRoute(){
            this.main_route = `/${this.cloudEngine}/workflows/${this.workflowId}/actions`
        },

        setSubscriptions(){
            this.bus.subscribe('show:/module/workflows/action', () => {
                this.show = ! this.show
            })
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
                    if(this.actions.length == 0){
                        this.active_tab = 1
                    }
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    beforeDestroy(){
        this.bus.$off('show:/module/workflows/action')
    }
}
</script>
<template>
    <div :class="[{ 'is-active': show }, 'quickview', 'is-size-large']">
        <header class="quickview-header">
            <h4 class="title">Workflow Actions</h4>
            <span class="delete" @click="show = false"></span>
        </header>
        <div class="quickview-body">
            <b-tabs expanded v-model="active_tab">
                <b-tab-item label="Actions List">
                    <b-table :data="actions">
                            <template slot-scope="props">
                                <b-table-column field="name" label="Name">
                                    <small>{{ props.row.name }}</small>
                                </b-table-column>
                                <b-table-column field="action_type" label="Type">
                                    <small>{{ props.row.action_type }}</small>
                                </b-table-column>
                                <b-table-column field="initial_status_name" label="Initial Status">
                                    <small>
                                        {{ object_utils.translateEnum(translations.statuses, 'status', props.row.initial_status_name) }}
                                    </small>
                                </b-table-column>
                                <b-table-column field="final_status_name" label="Final Status">
                                    <small>
                                        {{ object_utils.translateEnum(translations.statuses, 'status', props.row.final_status_name) }}
                                    </small>
                                </b-table-column>
                            </template>
                        </b-table>
                </b-tab-item>
                <b-tab-item label="New Action">
                </b-tab-item>
                <b-tab-item label="Edit Action">
                </b-tab-item>
            </b-tabs>
        </div>
    </div>
</template>
