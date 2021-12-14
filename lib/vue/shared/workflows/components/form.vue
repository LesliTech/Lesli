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
import componentAssociation from 'LesliVue/shared/workflows/components/association.vue'
import componentStatusName from 'LesliVue/shared/workflows/components/status-name.vue'
import componentWorkflowChart from 'LesliVue/shared/workflows/components/chart.vue'
import componentAction from 'LesliVue/shared/workflows/components/action.vue'
import componentCheck from 'LesliVue/shared/workflows/components/check.vue'

export default {
    props: {
        viewType: {
            type: String,
            default: 'new'
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
            required: true
        },

        workflowName: {
            type: String
        }
    },

    components: {
        'component-workflow-chart': componentWorkflowChart,
        'component-association': componentAssociation,
        'component-status-name': componentStatusName,
        'component-action': componentAction,
        'component-check': componentCheck
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                workflows: I18n.t('core.workflows')
            },
            rerender_chart: false,
            workflow: null,
            workflow_id: null,
            selected_workflow_status: {},
            selected_workflow_status_id: null,
            deleted_workflow_statuses: [],
            new_status_name: '',
            statuses_count: 0,
            active_tab: 0,
            cloud_engine: 'crm',
            to_be_deleted_statuses: {},
            main_route: null,
            submitting: false,
            submitting_status: false,
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

            this.$set(this.translations, 'main', I18n.t(`${this.translations_path}.workflows`))
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
            }else{
                this.workflow = {
                    name: '',
                    default: false,
                    statuses: {}
                }
            }
        },

        getWorkflow() {
            let url = `${this.main_route}/${this.workflow_id}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow = result.data
                    this.statuses_count = this.workflow.statuses_count
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        addStatusToWorkflow(event) {
            if(event){
                event.preventDefault();
            }

            let new_status = {
                next_statuses: '',
                visited: false,
                status_type: 'normal',
                number: 0,
                new_number: 0,
                name: this.new_status_name
            }
            if(this.statuses_count == 0){
                new_status.status_type = 'initial'
            }
            this.statuses_count+=1
            
            let data = {
                workflow_status: new_status
            }
            this.submitting_status = true

            let url = `${this.main_route}/${this.workflow_id}/statuses`
            this.http.post(url, data).then(result => {
                if (result.successful) {
                    new_status.id = result.data.id
                    this.$set(this.workflow.statuses, new_status.id, new_status)
                    this.msg.success(this.translations.workflows.messages_success_status_created)
                    this.new_status_name = ''
                    this.$refs['input-status-name'].focus()
                    this.rerender_chart = true
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting_status = false
            })
        },

        deleteStatusFromWorkflow(deleted_status){

            let deleted_status_id = deleted_status.id
            this.$delete(this.workflow.statuses, deleted_status_id)
            if(deleted_status.id){
                deleted_status['_destroy'] = true
                this.deleted_workflow_statuses.push(deleted_status)
            }

            for(let status_id in this.workflow.statuses){
                let workflow_status = this.workflow.statuses[status_id]

                if(workflow_status.next_statuses){
                    workflow_status.next_statuses = workflow_status.next_statuses.replace(
                        new RegExp(`([^0-9]${deleted_status_id}$)|(^${deleted_status_id}[^0-9])|(^${deleted_status_id}$)`,'g'), ''
                    ).replace(
                        new RegExp(`([^0-9]${deleted_status_id}[^0-9])`,'g'), '|'
                    )
                    if(workflow_status.next_statuses.length == 0){
                        workflow_status.next_statuses = null
                    }
                }
            }
            this.selected_workflow_status = {}
            this.rerender_chart = true
            this.msg.warn(this.translations.workflows.messages_info_status_deleted)
        },

        addFollowUpStatus(){
            if(this.selected_workflow_status_id != null){
                if(this.selected_workflow_status.next_statuses){
                    this.selected_workflow_status.next_statuses += `|${this.selected_workflow_status_id}`
                }else{
                    this.selected_workflow_status.next_statuses = `${this.selected_workflow_status_id}`
                }
                this.selected_workflow_status_id = null
                this.rerender_chart = true
            }
        },
        
        selectWorkflowStatus(workflow_status){
            this.selected_workflow_status = workflow_status
        },

        deleteFollowUpStatus(workflow_status){

            let status_id = workflow_status.id

            this.selected_workflow_status.next_statuses = this.selected_workflow_status.next_statuses.replace(
                new RegExp(`([^0-9]${status_id}$)|(^${status_id}[^0-9])|(^${status_id}$)`,'g'), ''
            ).replace(
                new RegExp(`([^0-9]${status_id}[^0-9])`,'g'), '|'
            )
            this.rerender_chart = true
        },

        verifyAndSubmitWorkflow(event){
            if(event){
                event.preventDefault()
            }

            this.syncWorkflowNumbers()

            let to_be_deleted_statuses = Object.values(this.to_be_deleted_statuses)
            this.to_be_deleted_statuses = {}
            if(to_be_deleted_statuses.length > 0){
                to_be_deleted_statuses = to_be_deleted_statuses.join(', ')

                window.scrollTo(0,0)
                this.$nextTick(()=>{
                    this.$buefy.dialog.confirm({
                        title: this.translations.workflows.messages_danger_statuses_marked_as_deleted,
                        message: `${this.translations.workflows.messages_danger_statuses_marked_as_deleted_1}: <b>${to_be_deleted_statuses}</b>. ${this.translations.workflows.messages_danger_statuses_marked_as_deleted_2}`,
                        confirmText: this.translations.core.view_btn_accept,
                        cancelText: this.translations.core.view_btn_cancel,
                        type: 'is-danger',
                        onConfirm: ()=>{
                            this.submitWorkflow()
                        }
                    })
                })
            }else{
                this.submitWorkflow()
            }
        },

        submitWorkflow(event){
            if(event){
                event.preventDefault()
            }

            if(this.workflow_id){
                this.putWorkflow()    
            }else{
                this.postWorkflow()
            }

        },

        syncWorkflowNumbers(){
            for(let key in this.workflow.statuses){
                let status = this.workflow.statuses[key]

                status.number = status.new_number
            }
        },

        postWorkflow(){
            if(this.workflow.name){
                let statuses_attributes = Object.values(this.workflow.statuses)
                
                let data = {
                    workflow: {
                        name: this.workflow.name,
                        statuses_attributes: statuses_attributes
                    }
                }

                this.submitting = true

                this.http.post(`${this.main_route}`, data).then(result => {
                    if (result.successful) {
                        this.msg.success(this.translations.workflows.messages_success_workflow_created)
                        
                        this.workflow = result.data
                        this.$router.push(`${this.appMountPath}/${result.data.id}/edit`)
                    }else{
                        this.msg.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                }).finally(()=>{
                    this.submitting = false
                })
            }else{
                this.$refs['input-workflow-name'].focus()
                this.msg.error(this.translations.workflows.messages_warning_workflow_name_missing)
            }
        },

        putWorkflow(){
            let statuses_attributes = Object.values(this.workflow.statuses).concat(this.deleted_workflow_statuses)

            let data = {
                workflow: {
                    name: this.workflow.name,
                    statuses_attributes: statuses_attributes
                }
            }
            let url = `${this.main_route}/${this.workflow_id}`
            this.submitting = true

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.workflows.messages_success_workflow_updated)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        submitWorkflowName(){
            let data = {
                workflow: {
                    name: this.workflow.name
                }
            }

            if(this.workflow_id){
                let url = `${this.main_route}/${this.workflow_id}`
                this.http.patch(url, data).then(result => {
                    if (result.successful) {
                        this.msg.success(this.translations.workflows.messages_success_workflow_name_updated)
                    }else{
                        this.msg.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }else{
                let url = `${this.main_route}`
                this.http.post(url, data).then(result => {
                    if (result.successful) {
                        this.workflow_id = result.data.id
                        this.msg.success(this.translations.workflows.messages_success_workflow_created)

                        this.$nextTick(()=>{
                            this.$refs["input-status-name"].focus()
                        })
                    }else{
                        this.msg.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        selectAsInitial(selected_status){
            for(let key in this.workflow.statuses){
                let status = this.workflow.statuses[key]

                if(status.id == selected_status.id){
                    status.status_type = 'initial'
                    continue
                }

                if(status.status_type == 'initial'){
                    status.status_type = 'normal'
                }
            }
        },

        changeStatusType(selected_status, new_status_type){
            if(selected_status.status_type == new_status_type){
                selected_status.status_type = 'normal'
            }else{
                selected_status.status_type = new_status_type
            }

            // We should keep the statuses marked as to be deleted in a special array for a final alert
            if(new_status_type == 'to_be_deleted'){
                if(selected_status.status_type == new_status_type){
                    this.to_be_deleted_statuses[selected_status.name] = this.object_utils.translateEnum(this.translations.core, 'column_enum_status', selected_status.name)
                }else{
                    delete this.to_be_deleted_statuses[selected_status.name]
                }
            }
        },

        deleteWorkflow(){
            let url = `${this.main_route}/${this.workflow_id}`
            this.submitting = true

            this.http.delete(url).then(result => {
                if(result.successful){
                    this.msg.success(this.translations.workflows.messages_info_workflow_deleted)
                    this.$router.push(`${this.appMountPath}/`)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
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
        }
    },

    computed: {
        
        nextStatusesOfSelectedStatus(){
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
            return next_statuses.sort(function(status_1, status_2){
                return (status_1.number || 0) - (status_2.number || 0)
            })
        },

        possibleFollowUpStatuses(){
            let label = [{id: null, name: this.translations.workflows.view_placeholder_select_status}]

            if(this.selected_workflow_status.id == null){
                return label
            }

            if(! this.selected_workflow_status.next_statuses){
                label = label.concat(Object.values(this.workflow.statuses))
                label.sort((a,b) => a.number - b.number)
                return label
            }
            
            let follow_up_statuses  = this.selected_workflow_status.next_statuses.split('|').map((element)=>{
                return parseInt(element)
            })

            label =  label.concat(Object.values(this.workflow.statuses).filter(element => {
                return ! follow_up_statuses.includes(element.id)
            }))

            return label.sort((a,b) => a.number - b.number)
        },

        orderedWorkflowStatuses(){
            if(! this.workflow.statuses){
                return []
            }
            
            return Object.values(this.workflow.statuses).sort(function(status_1, status_2){
                return (status_1.number || 0) - (status_2.number || 0)
            })
        }
    },

    watch: {
        'workflow.name'(){
            this.$emit('update:workflow-name', this.workflow.name)
        }
    }
}
</script>
<template>
    <b-tabs v-if="workflow" vertical v-model="active_tab">
        <b-tab-item :label="translations.workflows.view_tab_title_edition_mode">
            <div class="card" >
                <div class="card-content">
                    <h5 class="title is-5">{{translations.workflows.view_title_workflow_configuration}}</h5>
                    <div class="columns">
                        <div :class="{'column is-12' :viewType == 'new', 'column is-10': viewType == 'edit'}">
                            <b-field :label="translations.workflows.column_name">
                                <input
                                    class="input"
                                    @change="submitWorkflowName"
                                    v-model="workflow.name"
                                    type="text"
                                    ref="input-workflow-name"
                                    required
                                />
                            </b-field>
                        </div>
                        <div v-if="viewType == 'edit'" class="column is-2">
                            <b-field :label="translations.workflows.column_default">
                                <b-checkbox v-model="workflow.default" @change.native="patchWorkflowDefault">
                                    <span v-if="workflow.default">{{translations.core.view_text_yes}}</span>
                                    <span v-else>{{translations.core.view_text_no}}</span>
                                </b-checkbox>
                            </b-field>
                        </div>
                    </div>
                    <hr>
                    <form @submit="addStatusToWorkflow">
                        <div class="columns">
                            <div class="column is-11">
                                <b-field :label="translations.workflows.view_title_add_new_status">
                                    <b-input v-model="new_status_name" ref="input-status-name" required :readonly="! workflow_id">
                                    </b-input>
                                </b-field>
                            </div>
                            <div class="column is-1 has-text-right">
                                <b-field>
                                    <template v-slot:label>
                                        &nbsp;
                                    </template>
                                    <b-button :disabled="submitting_status" type="is-primary" native-type="submit" expanded class="submit-button">
                                        <i v-if="submitting_status" class="fas fa-circle-notch fa-spin"> </i>
                                        <i v-else class="fas fa-plus-square"> </i>
                                    </b-button>
                                </b-field>
                            </div>
                        </div>
                    </form>
                    <br>
                    <form @submit="verifyAndSubmitWorkflow">
                        <div class="columns">
                            <div class="column is-7">
                                <span class="has-text-weight-bold">
                                    {{translations.workflows.view_title_select_status}}
                                </span>
                                <div class="menu-list is-bg-dark is-hoverable">
                                    <a 
                                        v-for="(status) in orderedWorkflowStatuses"
                                        :key="status.id"
                                        class="list-item"
                                        @click="selectWorkflowStatus(status)"
                                        :class="{'is-active':selected_workflow_status.id == status.id}"
                                    >
                                        <div class="columns">
                                            <div class="column is-paddingless-right is-7">
                                                {{object_utils.translateEnum(translations.core, 'column_enum_status', status.name)}}
                                            </div>
                                            <div class="column is-paddingless-x is-2">
                                                <b-input size="is-small" type="text" pattern="\d+" v-model="status.new_number"></b-input>
                                            </div>
                                            <div class="column is-paddingless-left is-3">
                                                <span class="is-pulled-right has-background-white">
                                                    &nbsp;
                                                    <b-tooltip position="is-top" :label="translations.workflows.messages_info_tooltip_status_initial" type="is-primary">
                                                        <b-icon
                                                            @click.native="selectAsInitial(status)"
                                                            size="is-small"
                                                            icon="play-circle"
                                                            :class="{'has-text-grey-light': status.status_type != 'initial', 'has-text-primary': status.status_type == 'initial'}"
                                                        >
                                                        </b-icon>
                                                    </b-tooltip>
                                                    <b-tooltip position="is-top" :label="translations.workflows.messages_info_tooltip_status_completed_successfully" type="is-success">
                                                        <b-icon
                                                            size="is-small"
                                                            icon="check-circle"
                                                            @click.native="changeStatusType(status, 'completed_successfully')"
                                                            :class="{'has-text-grey-light': status.status_type != 'completed_successfully', 'has-text-success': status.status_type == 'completed_successfully'}"
                                                        >
                                                        </b-icon>
                                                    </b-tooltip>
                                                    <b-tooltip position="is-top" :label="translations.workflows.messages_info_tooltip_status_completed_unsuccessfully" type="is-warning">
                                                        <b-icon
                                                            size="is-small"
                                                            icon="times-circle"
                                                            @click.native="changeStatusType(status, 'completed_unsuccessfully')"
                                                            :class="{'has-text-grey-light': status.status_type != 'completed_unsuccessfully', 'has-text-warning': status.status_type == 'completed_unsuccessfully'}"
                                                        >
                                                        </b-icon>
                                                    </b-tooltip>
                                                    <b-tooltip position="is-top" :label="translations.workflows.messages_info_tooltip_status_to_be_deleted" type="is-danger">
                                                        <b-icon
                                                            size="is-small"
                                                            icon="eraser"
                                                            @click.native="changeStatusType(status, 'to_be_deleted')"
                                                            :class="{'has-text-grey-light': status.status_type != 'to_be_deleted', 'has-text-danger': status.status_type == 'to_be_deleted'}"
                                                        >
                                                        </b-icon>
                                                    </b-tooltip>
                                                    &nbsp;
                                                </span>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                <br>
                                <b-button
                                    type="is-danger"
                                    outlined
                                    :disabled="! selected_workflow_status.id || selected_workflow_status.status_type == 'initial'"
                                    @click="deleteStatusFromWorkflow(selected_workflow_status)"
                                >
                                    <b-icon size="is-small" icon="trash-alt"></b-icon>
                                    &nbsp;
                                    {{translations.workflows.view_btn_delete_selected_status}}
                                </b-button>
                            </div>
                            <div class="column is-5">
                                <label class="label">{{translations.workflows.view_title_select_transition_status}}</label>
                                <div class="columns">
                                    <div class="column">
                                        <b-field>
                                            <div class="control is-expanded">
                                                <span class="select is-fullwidth is-empty">
                                                    <select v-model="selected_workflow_status_id" @change="addFollowUpStatus">
                                                        <option
                                                            v-for="workflow_status in possibleFollowUpStatuses"
                                                            :value="workflow_status.id"
                                                            :key="workflow_status.id"
                                                            :hidden="workflow_status.id == null"
                                                            :disabled="workflow_status.id == null"  
                                                        >
                                                            {{object_utils.translateEnum(translations.core, 'column_enum_status', workflow_status.name)}}
                                                        </option>
                                                    </select>
                                                </span>
                                            </div>
                                        </b-field>
                                    </div>
                                </div>
                                <div class="columns">
                                    <div class="column">
                                        <span class="has-text-weight-bold">
                                            {{translations.workflows.view_title_transition_statuses_list}}
                                        </span>
                                        <div class="menu-list is-hoverable">
                                            <a v-for="(workflow_status, key) in nextStatusesOfSelectedStatus" :key="key" class="list-item">
                                                {{workflow_status.number}} -
                                                {{object_utils.translateEnum(translations.core, 'column_enum_status', workflow_status.name)}}
                                                <button type="button" class="delete is-pulled-right" @click="deleteFollowUpStatus(workflow_status)">
                                                </button>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="columns">
                            <div class="column">
                                <div class="field">
                                    <div class="actions has-text-right">
                                        <b-button :disabled="submitting" type="is-primary" expanded native-type="submit" class="submit-button">
                                            <span v-if="submitting">
                                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small">
                                                </b-icon>
                                                <span> {{translations.core.view_btn_saving}} </span>
                                            </span>
                                            <span v-else>
                                                <b-icon icon="save" size="is-small">
                                                </b-icon>
                                                <span> {{translations.core.view_btn_save}} </span>
                                            </span>
                                        </b-button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </b-tab-item>
        <b-tab-item :label="translations.workflows.view_tab_title_graphic_mode">
            <div class="card">
                <div class="card-content">
                    <component-workflow-chart
                        v-if="active_tab == 1"
                        class="has-text-centered"
                        translations-path="core.workflows" 
                        :engine-namespace="engineNamespace"
                        :workflow="workflow"
                        :rerender.sync="rerender_chart"
                    />
                </div>
            </div>
        </b-tab-item>
        <b-tab-item :label="translations.workflows.view_btn_workflow_actions" v-if="viewType != 'new'">
            <div class="card">
                <div class="card-content">
                    <component-action
                        :engine-namespace="engineNamespace"
                        :workflow-id="workflow_id"
                        :translations-path="`${translations_path}.workflow/actions`"
                        statuses-translations-path="core.shared"
                    >
                    </component-action>
                </div>
            </div>
        </b-tab-item>
        <b-tab-item :label="translations.workflows.view_tab_title_checks" v-if="viewType != 'new'">
            <div class="card">
                <div class="card-content">
                    <component-check
                        :engine-namespace="engineNamespace"
                        :workflow-id="workflow_id"
                        :translations-path="`${translations_path}.workflow/checks`"
                        statuses-translations-path="core.shared"
                    >
                    </component-check>
                </div>
            </div>
        </b-tab-item>
        <b-tab-item :label="translations.workflows.view_btn_workflow_associations" v-if="viewType != 'new'">
            <div class="card">
                <div class="card-content">
                    <component-association
                        :engine-namespace="engineNamespace"
                        :workflow-id="workflow_id"
                        :translations-path="`${translations_path}.workflow/associations`"
                        statuses-translations-path="core.shared"
                    >
                    </component-association>
                </div>
            </div>
        </b-tab-item>
        <b-tab-item :label="translations.core.view_tab_title_delete_section" v-if="viewType != 'new' && (! workflow.deletion_protection)">
            <div class="card">
                <div class="card-content">
                    <h5 class="title is-5">{{translations.workflows.view_title_delete_workflow}}</h5>
                    <span class="has-text-danger">
                        {{translations.workflows.messages_danger_delete_workflow_description}}
                    </span>
                    <br>
                    <br>
                    <b-field v-if="viewType != 'new'">
                        <b-button type="is-danger" @click="deleteWorkflow" expanded class="submit-button" :disabled="submitting">
                            <span v-if="submitting">
                                <i class="fas fa-spin fa-circle-notch"></i> {{translations.core.view_btn_deleting}}
                            </span>
                            <span v-else>
                                <i class="fas fa-trash-alt"></i> {{translations.core.view_btn_delete}}
                            </span>
                        </b-button>
                    </b-field>
                </div>
            </div>
        </b-tab-item>
    </b-tabs>
</template>
