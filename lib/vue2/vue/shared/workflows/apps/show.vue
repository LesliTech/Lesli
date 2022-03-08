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

// · Component list
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentChart from 'LesliVue/shared/workflows/components/chart.vue'

export default {
    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        },

        translationsPath: {
            type: String,
            default: null
        },

        appMountPath: {
            type: String,
            default: ''
        }
    },

    components: {
        'component-chart': componentChart
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                workflows: I18n.t('core.workflows')
            },
            workflow: null,
            workflow_id: null,
            active_tab: 0,
            selected_workflow_status: {},
            translations_path: null
        }
    },
    mounted() {
        this.setTranslations()
        this.setMainRoute()
        this.setWorkflowId()
    },
    methods: {
        setTranslations(){
            this.translations_path = this.translationsPath
            if(! this.translations_path){
                this.translations_path = this.engineNamespace
            }

            this.$set(this.translations, 'shared', I18n.t(`${this.translations_path}.shared`))
        },

        setMainRoute(){
            // Engines like mitwerken use root as namespace
            if(this.engineNamespace == '/'){
                this.main_route = '/workflows'
            }else{
                this.main_route = `/${this.engineNamespace}/workflows`
            }
        },
        
        setWorkflowId(){
            if (this.$route.params.id) {
                this.workflow_id = this.$route.params.id
                this.getWorkflow()
            }
        },

        getWorkflow() {
            let url = `${this.main_route}/${this.workflow_id}.json`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow = result.data
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowDefault() {
            let url = `${this.main_route}/${this.workflow_id}`
            let data = {
                workflow: {
                    default: true
                }
            }
            this.http.patch(url, data).then(result => {
                if(result.successful){
                    this.workflow.default = true
                    this.msg.success(this.translations.workflows.messages_success_workflow_set_as_default)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        selectWorkflowStatus(status){
            this.selected_workflow_status = status
        },

        tooltipButtonInitial(status){
            if(status.status_type == 'initial'){
                return this.translations.workflows.messages_info_tooltip_status_initial
            }
            return ''
        },

        tooltipButtonCompletedSuccessfully(status){
            if(status.status_type == 'completed_successfully'){
                return this.translations.workflows.messages_info_tooltip_status_completed_successfully
            }
            return ''
        },

        tooltipButtonCompletedUnsuccessfully(status){
            if(status.status_type == 'completed_unsuccessfully'){
                return this.translations.workflows.messages_info_tooltip_status_completed_unsuccessfully
            }
            return ''
        },

        tooltipButtonToBeDeleted(status){
            if(status.status_type == 'to_be_deleted'){
                return this.translations.workflows.messages_info_tooltip_status_to_be_deleted
            }
            return ''
        }
    },

    computed: {
        selectedStatusTransitions(){
            let next_statuses = []
            if(! this.workflow.statuses[this.selected_workflow_status.id]){
                return next_statuses
            }
            
            if(this.selected_workflow_status.next_statuses){
                let next_statuses_ids = this.selected_workflow_status.next_statuses.split('|')
                next_statuses_ids.forEach((id)=>{
                    next_statuses.push(this.workflow.statuses[id])
                })
            }
            return next_statuses.sort((a,b) => a.number - b.number)
        },

        orderedWorkflowStatuses(){
            if(! this.workflow.statuses){
                return []
            }
            
            return Object.values(this.workflow.statuses).sort(function(status_1, status_2){
                return (status_1.number || 0) - (status_2.number || 0)
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow" class="application-component">
        <nav class="navbar component-header">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <div class="navbar-item">
                        <h4 class="is-size-3">
                            {{ workflow.name }} &nbsp;
                            <span v-if="workflow.default" class="has-text-info">
                                ({{translations.workflows.column_default}})
                            </span>
                        </h4>
                    </div>
                </div>
                <div class="navbar-end">
                    <div class="navbar-item">
                        <div class="buttons">
                            <router-link :to="`${appMountPath}/`" class="button">
                                <b-icon icon="list" size="is-small"></b-icon>
                                <span>{{translations.core.view_btn_list}}</span>
                            </router-link>
                            <router-link :to="`${appMountPath}/${workflow_id}/edit`" class="button">
                                <b-icon icon="edit" size="is-small"></b-icon>
                                <span>{{translations.core.view_btn_edit}}</span>
                            </router-link>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <b-tabs vertical v-model="active_tab">
            <b-tab-item :label="translations.workflows.view_tab_title_edition_mode">
                <div class="card">
                    <div class="card-content">
                        <div class="columns">
                            <div class="column is-6">
                                <h5 class="title is-5">
                                    {{translations.workflows.view_title_statuses_list}}
                                </h5>
                                <div class="menu-list workflow-statuses-list is-hoverable">
                                    <a 
                                        v-for="(status) in orderedWorkflowStatuses"
                                        :key="status.id"
                                        class="list-item"
                                        @click="selectWorkflowStatus(status)"
                                        :class="{'is-active':selected_workflow_status.id == status.id}"
                                    >
                                        <b-tooltip  :label="translations.workflows.messages_info_tooltip_status_step" type="is-light" position="is-top">
                                            {{status.number}}
                                        </b-tooltip>
                                        -
                                        {{object_utils.translateEnum(translations.core, 'column_enum_status', status.name)}}
                                        <span class="is-pulled-right has-background-white">
                                            &nbsp;
                                            <b-tooltip position="is-top" :label="tooltipButtonInitial(status)" type="is-primary">
                                                <b-icon
                                                    size="is-small"
                                                    icon="play-circle"
                                                    :class="{'has-text-grey-light': status.status_type != 'initial', 'has-text-primary': status.status_type == 'initial'}"
                                                >
                                                </b-icon>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonCompletedSuccessfully(status)" type="is-success">
                                                <b-icon
                                                    size="is-small"
                                                    icon="check-circle"
                                                    :class="{'has-text-grey-light': status.status_type != 'completed_successfully', 'has-text-success': status.status_type == 'completed_successfully'}"
                                                >
                                                </b-icon>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonCompletedUnsuccessfully(status)" type="is-warning">
                                                <b-icon
                                                    size="is-small"
                                                    icon="times-circle"
                                                    :class="{'has-text-grey-light': status.status_type != 'completed_unsuccessfully', 'has-text-warning': status.status_type == 'completed_unsuccessfully'}"
                                                >
                                                </b-icon>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonToBeDeleted(status)" type="is-danger">
                                                <b-icon
                                                    size="is-small"
                                                    icon="eraser"
                                                    :class="{'has-text-grey-light': status.status_type != 'to_be_deleted', 'has-text-danger': status.status_type == 'to_be_deleted'}"
                                                >
                                                </b-icon>
                                            </b-tooltip>
                                            &nbsp;
                                        </span>
                                    </a>
                                </div>
                            </div>
                            <div class="column is-6">
                                <h5 class="title is-5">
                                    {{translations.workflows.view_title_transitions_list}}
                                </h5>
                                <div class="menu-list workflow-statuses-list">
                                    <a v-for="(status, key) in selectedStatusTransitions" :key="key" class="list-item">
                                        {{status.number}} -
                                        {{object_utils.translateEnum(translations.core, 'column_enum_status', status.name)}}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </b-tab-item>
            <b-tab-item  :label="translations.workflows.view_tab_title_graphic_mode">
                <div class="card">
                    <div class="card-content">
                        <component-chart
                            v-if="active_tab == 1"
                            class="has-text-centered"
                            translations-path="core.workflows" 
                            :engine-namespace="engineNamespace"
                            :workflow="workflow"
                        >
                        </component-chart>
                    </div>
                </div>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
