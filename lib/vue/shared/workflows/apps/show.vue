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
import componentAssociation from 'LesliVue/shared/workflows/components/association.vue'
import componentAction from 'LesliVue/shared/workflows/components/action.vue'
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
        }
    },

    components: {
        'component-chart': componentChart,
        'component-association': componentAssociation,
        'component-action': componentAction
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
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        publishShowWorkflowAssociation(){
            this.bus.publish('show:/module/workflows/association')
        },

        publishShowWorkflowActions(){
            this.bus.publish('show:/module/workflows/action')
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
                    this.alert(this.translations.workflows.messages_success_workflow_set_as_default, 'success')
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteWorkflow(){
            let url = `${this.main_route}/${this.workflow_id}`
            this.http.delete(url).then(result => {
                if(result.successful){
                    this.alert(this.translations.workflows.messages_info_workflow_deleted, 'success')
                    this.$router.push('/')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        confirmDeletion() {
            window.scrollTo(0,0)
            this.$buefy.dialog.confirm({
                title: this.translations.workflows.messages_danger_delete_workflow_title,
                message: this.translations.workflows.messages_danger_delete_workflow_description,
                confirmText: this.translations.workflows.messages_danger_delete_workflow_accept,
                cancelText: this.translations.shared.view_btn_cancel,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteWorkflow()
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
            return next_statuses
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
                            {{translations.workflows.view_title_main}}
                        </h4>
                    </div>
                </div>
                <div class="navbar-end">
                    <div class="navbar-item">
                        <div class="buttons">
                            <router-link to="/" class="button">
                                <b-icon icon="list" size="is-small"></b-icon>
                                <span>{{translations.core.view_btn_list}}</span>
                            </router-link>
                            <router-link :to="`/${workflow_id}/edit`" class="button">
                                <b-icon icon="edit" size="is-small"></b-icon>
                                <span>{{translations.core.view_btn_edit}}</span>
                            </router-link>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    {{ workflow.name }} &nbsp;
                    <span v-if="workflow.default" class="has-text-info">
                        ({{translations.workflows.column_default}})
                    </span>
                </h2>
                <div class="card-header-icon">
                    <span v-if="workflow.default" class="has-text-gray">
                        <i class="fas fa-check-circle"></i>
                        {{translations.workflows.view_btn_set_as_default}}
                    </span>
                    <a v-else href="javascript:void(0)" @click="patchWorkflowDefault">
                        <i class="fas fa-check-circle"></i>
                        {{translations.workflows.view_btn_set_as_default}}
                    </a>
                    <a role="button" @click="publishShowWorkflowActions">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-paperclip"></i>
                        {{translations.workflows.view_btn_workflow_actions}}
                    </a>
                    <a role="button" @click="publishShowWorkflowAssociation">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-globe"></i>
                        {{translations.workflows.view_btn_workflow_associations}}
                    </a>
                </div>
            </div>
            <div class="card-content">
                <b-tabs v-model="active_tab">
                    <b-tab-item :label="translations.workflows.view_tab_title_edition_mode">
                        <div class="columns">
                            <div class="column is-6">
                                <h5 class="title is-5">
                                    {{translations.workflows.view_title_statuses_list}}
                                </h5>
                                <div class="menu-list workflow-statuses-list is-bg-dark is-hoverable">
                                    <a 
                                        v-for="(status) in orderedWorkflowStatuses"
                                        :key="status.id"
                                        class="list-item"
                                        @click="selectWorkflowStatus(status)"
                                        :class="{'is-active':selected_workflow_status.id == status.id}"
                                    >
                                        {{object_utils.translateEnum(translations.core, 'column_enum_status', status.name)}} - 
                                        <b-tooltip  :label="translations.workflows.messages_info_tooltip_status_step" type="is-light" position="is-top">
                                            {{status.number}}
                                        </b-tooltip>
                                        <span class="is-pulled-right">
                                            <b-tooltip position="is-top" :label="tooltipButtonInitial(status)" type="is-primary">
                                                <b-button size="is-small" type="is-primary" :outlined="status.status_type != 'initial'" disabled>
                                                    <b-icon size="is-small" icon="play-circle">
                                                    </b-icon>
                                                </b-button>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonCompletedSuccessfully(status)" type="is-success">
                                                <b-button
                                                    size="is-small" type="is-success"
                                                    :outlined="status.status_type != 'completed_successfully'"
                                                    disabled
                                                >
                                                    <b-icon size="is-small" icon="check-circle">
                                                    </b-icon>
                                                </b-button>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonCompletedUnsuccessfully(status)" type="is-warning">
                                                <b-button
                                                    size="is-small" type="is-warning"
                                                    :outlined="status.status_type != 'completed_unsuccessfully'"
                                                    disabled
                                                >
                                                    <b-icon size="is-small" icon="check-circle">
                                                    </b-icon>
                                                </b-button>
                                            </b-tooltip>
                                            <b-tooltip position="is-top" :label="tooltipButtonToBeDeleted(status)" type="is-danger">
                                                <b-button
                                                    size="is-small" type="is-danger"
                                                    :outlined="status.status_type != 'to_be_deleted'"
                                                    disabled
                                                >
                                                    <b-icon size="is-small" icon="exclamation-circle">
                                                    </b-icon>
                                                </b-button>
                                            </b-tooltip>
                                        </span>
                                    </a>
                                </div>
                            </div>
                            <div class="column is-6">
                                <h5 class="title is-5">
                                    {{translations.workflows.view_title_transitions_list}}
                                </h5>
                                <div class="menu-list workflow-statuses-list">
                                    <a v-for="(workflow_status, key) in selectedStatusTransitions" :key="key" class="list-item">
                                        {{object_utils.translateEnum(translations.core, 'column_enum_status', workflow_status.name)}}
                                        <span class="is-pulled-right">
                                            <b-button size="is-small" type="is-primary" :outlined="workflow_status.status_type != 'initial'" disabled>
                                                <b-icon size="is-small" icon="play-circle">
                                                </b-icon>
                                            </b-button>
                                            <b-button
                                                size="is-small" type="is-success"
                                                :outlined="workflow_status.status_type != 'completed_successfully'"
                                                disabled
                                            >
                                                <b-icon size="is-small" icon="check-circle">
                                                </b-icon>
                                            </b-button>
                                            <b-button
                                                size="is-small" type="is-warning"
                                                :outlined="workflow_status.status_type != 'completed_unsuccessfully'"
                                                disabled
                                            >
                                                <b-icon size="is-small" icon="check-circle">
                                                </b-icon>
                                            </b-button>
                                            <b-button
                                                size="is-small" type="is-danger"
                                                :outlined="workflow_status.status_type != 'to_be_deleted'"
                                                disabled
                                            >
                                                <b-icon size="is-small" icon="exclamation-circle">
                                                </b-icon>
                                            </b-button>
                                        </span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </b-tab-item>
                    <b-tab-item  :label="translations.workflows.view_tab_title_graphic_mode">
                        <component-chart
                            v-if="active_tab == 1"
                            class="has-text-centered"
                            translations-path="core.workflows" 
                            :engine-namespace="engineNamespace"
                            :workflow="workflow"
                        >
                        </component-chart>
                    </b-tab-item>
                </b-tabs>
                <div class="columns">
                    <div class="column">
                        <small>
                            <span class="has-text-weight-bold">
                                {{translations.core.column_created_at}}:
                            </span>
                            {{ workflow.created_at }}
                        </small>
                    </div>
                    <div class="column">
                        <div class="field">
                            <div class="actions has-text-right">
                                <b-tooltip
                                    type="is-danger"
                                    position="is-left"
                                    multilined
                                    :active="workflow.deletion_protection"
                                    :label="translations.workflows.messages_warning_tooltip_workflow_protected_from_deletion"
                                >
                                    <b-button type="is-danger" outlined @click="confirmDeletion()" :disabled="workflow.deletion_protection">
                                        <b-icon size="is-small" icon="trash-alt" />
                                        &nbsp;
                                        {{translations.core.view_btn_delete}}
                                    </b-button>
                                </b-tooltip>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <component-association
            :engine-namespace="engineNamespace"
            :workflow-id="workflow_id"
            :translations-path="`${translations_path}.workflow/associations`"
        >
        </component-association>
        <component-action
            :engine-namespace="engineNamespace"
            :workflow-id="workflow_id"
            :translations-path="`${translations_path}.workflow/actions`"
            statuses-translations-path="core.shared"
        >
        </component-action>
    </section>
</template>
