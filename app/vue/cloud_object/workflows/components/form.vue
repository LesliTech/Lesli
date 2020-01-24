<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@dev      Carlos Hermosilla
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Component list
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentWorkflowStateCrud from "LesliCloud/vue/cloud_object/workflow_states/components/crud.vue"
import componentWorkflowStateName from "LesliCloud/vue/cloud_object/workflow_states/components/state-name.vue"
import componentWorkflowChart from "LesliCloud/vue/cloud_object/workflows/components/chart.vue"

export default {
    components: {
        'component-workflow-chart': componentWorkflowChart,
        'component-workflow-state-name': componentWorkflowStateName,
        'component-workflow-state-crud': componentWorkflowStateCrud
    },
    
    props: {
        cloudModule: {
            type: String,
            required: true
        }
    },

    data() {
        return {
            module_name: null,
            object_name: null,
            rerender_chart: false,
            default_workflow_states: {
                initial: null,
                final: null
            },
            workflow: null,
            workflow_id: null,
            workflow_states: null,
            selected_workflow_detail: {},
            selected_workflow_state_id: null
        }
    },
    mounted() {
        // · setWorkflowId() calls getWorkflow()
        this.setCloudParams()
        this.setWorkflowId()
    },
    methods: {

        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },
        
        setWorkflowId(){
            if (this.$route.params.id) {
                this.workflow_id = this.$route.params.id
                this.getWorkflow()
            }else{
                this.workflow = {
                    name: '',
                    details: {}
                }
            }
        },

        setWorkflowStates(workflow_states){
            this.workflow_states = workflow_states
            if(! this.workflow_id){
                let initial_state = this.workflow_states.filter(state => state.id === this.default_workflow_states.initial)[0]
                let final_state = this.workflow_states.filter(state => state.id === this.default_workflow_states.final)[0]

                this.workflow.details[initial_state.id] = {
                    next_states: `${final_state.id}`,
                    initial: true,
                    workflow_state_id: initial_state.id,
                    workflow_state_name: initial_state.name,
                    visited: false
                }
                this.workflow.details[final_state.id] = {
                    next_states: null,
                    final: true,
                    workflow_state_id: final_state.id,
                    workflow_state_name: final_state.name,
                    visited: false
                }
                this.rerender_chart = true
            }
        },

        setWorkflowStateName(workflow_state){
            if(this.workflow.details[workflow_state.id]){
                this.workflow.details[workflow_state.id].workflow_state_name = workflow_state.name
            }
        },

        getWorkflow() {
            let url = `/${this.module_name}/${this.object_name}_workflows/${this.workflow_id}.json`
            console.log(url)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        addStateToWorkflow(workflow_state){
            let new_detail = {
                next_states: this.default_workflow_states.final.toString(),
                visited: false,
                workflow_state_id: workflow_state.id,
                workflow_state_name: workflow_state.name
            }
            this.workflow.details[this.default_workflow_states.initial].next_states+=`|${workflow_state.id}`
            this.$set(this.workflow.details, workflow_state.id, new_detail)
        },

        // · Checks if this is the only follow up state of the initial state
        // · node = state from which a follow up will be removed. If the user wants to remove from the workflow, this will be the initial state
        // · state_id = the id of the state the user wants to remove
        isRemovable(workflow_detail, workflow_state_id){
            if(workflow_detail.workflow_state_id == this.default_workflow_states.initial){
                return workflow_detail.next_states != workflow_state_id
            }
            return true
        },

        deleteStateFromWorkflow(workflow_state){
            let id = workflow_state.workflow_state_id

            if(this.isRemovable(this.workflow.details[this.default_workflow_states.initial], id)){
                this.$delete(this.workflow.details, id)

                for(let workflow_detail_id in this.workflow.details){
                    let workflow_detail = this.workflow.details[workflow_detail_id]

                    if(workflow_detail.next_states){
                        workflow_detail.next_states = workflow_detail.next_states.replace(
                            new RegExp(`([^0-9]${id}$)|(^${id}[^0-9])|(^${id}$)`,'g'), ''
                        ).replace(
                            new RegExp(`([^0-9]${id}[^0-9])`,'g'), '|'
                        )
                        if(workflow_detail.next_states.length == 0){
                            workflow_detail.next_states = null
                        }
                    }
                }
            }else{
                this.alert(
                    'The initial state needs a follow up at all times. Please add another follow up state before deleting this one',
                    'danger'
                )
            }
        },

        addFollowUpState(){
            if(this.selected_workflow_state_id){
                if(this.selected_workflow_detail.next_states){
                    this.selected_workflow_detail.next_states += `|${this.selected_workflow_state_id}`
                }else{
                    this.selected_workflow_detail.next_states = `${this.selected_workflow_state_id}`
                }
                this.selected_workflow_state_id = null
                this.rerender_chart = true
            }
        },
        
        selectWorkflowDetail(workflow_detail){
            this.selected_workflow_detail = workflow_detail
        },

        deleteFollowUpState(workflow_detail){

            let id = workflow_detail.workflow_state_id

            if(this.isRemovable(this.selected_workflow_detail, id)){
                this.selected_workflow_detail.next_states = this.selected_workflow_detail.next_states.replace(
                    new RegExp(`([^0-9]${id}$)|(^${id}[^0-9])|(^${id}$)`,'g'), ''
                ).replace(
                    new RegExp(`([^0-9]${id}[^0-9])`,'g'), '|'
                )
                this.rerender_chart = true
            }else{
                this.alert(
                    'The initial state needs a follow up at all times. Please add another follow up state before deleting this one',
                    'danger'
                )
            }
        },

        submitWorkflow(event){
            event.preventDefault()

            if(this.workflow_id){
                this.putWorkflow()    
            }else{
                this.postWorkflow()
            }
        },

        postWorkflow(){
            if(this.workflow.name){
                let data = {}
                data[`${this.object_name}_workflow`] = {
                    name: this.workflow.name
                }
                data[`${this.object_name}_workflow`].details_attributes = Object.values(
                    this.workflow.details
                ).map((detail)=>{
                    detail[`cloud_${this.module_name}_${this.object_name}_workflow_states_id`] = detail['workflow_state_id']
                    return detail
                })
                let url = `/${this.module_name}/${this.object_name}_workflows`

                this.http.post(url, data).then(result => {
                    if (result.successful) {
                        this.alert('Workflow created successfully', 'success')
                        this.$router.push(`/${result.data.id}`)
                    }else{
                        this.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }else{
                this.$refs['input-workflow-name'].focus()
                this.alert('Please provide a name for this workflow','danger')
            }
        },

        putWorkflow(){
            let data = {}
            data[`${this.object_name}_workflow`] = {
                name: this.workflow.name
            }
            data[`${this.object_name}_workflow`].details_attributes = Object.values(
                this.workflow.details
            ).map((detail)=>{
                detail[`cloud_${this.module_name}_${this.object_name}_workflow_states_id`] = detail['workflow_state_id']
                return detail
            })
            let url = `/${this.module_name}/${this.object_name}_workflows/${this.workflow_id}`

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.alert('Workflow updated successfully')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowName(){
            if(this.workflow_id){let data = {}
                data[`${this.object_name}_workflow`] = {
                    name: this.workflow.name
                }
                let url = `/${this.module_name}/${this.object_name}_workflows/${this.workflow_id}`

                this.http.patch(url, data).then(result => {
                    if (result.successful) {
                        this.alert('Workflow name successfully updated', 'success')
                    }else{
                        this.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    },
    computed: {
        
        nextStatesOfSelectedWorkflowDetail(){
            let next_states = []
            if(this.selected_workflow_detail.next_states){
                let next_states_ids = this.selected_workflow_detail.next_states.split('|')
                next_states_ids.forEach((id)=>{
                    next_states.push(this.workflow.details[id])
                })
            }
            return next_states
        },

        possibleFollowUpStates(){
            let label = [{id: null, name: 'Select a follow up state to add'}]
            if(
                ! this.selected_workflow_detail.workflow_state_id || 
                this.selected_workflow_detail.workflow_state_id == this.default_workflow_states.final
            ){
                return label
            }
            let follow_up_states  = this.selected_workflow_detail.next_states.split('|').map((element)=>{
                return parseInt(element)
            })
            return label.concat(this.workflow_states.filter(element => {
                return ! (
                    follow_up_states.includes(element.id) ||
                    element.id == this.default_workflow_states.initial
                ) && (
                    this.workflow.details[element.id]
                )
            }))
        }
    }
}
</script>
<template>
    <section v-if="workflow">
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    Ticket Workflow
                </h2>
                <div class="card-header-icon">
                    <router-link :to="`/${workflow_id}`">
                        <i class="fas fa-eye"></i>
                        Show Workflow
                    </router-link>
                    <router-link :to="`/`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-undo"></i>
                        Return
                    </router-link>
                </div>
            </div>
            <div class="card-content">
                <b-field label="Name">
                    <input
                        class="input"
                        @change="patchWorkflowName"
                        v-model="workflow.name"
                        type="text"
                        ref="input-workflow-name"
                        required
                    />
                </b-field>
                <hr>
                <component-workflow-state-crud
                    class="has-margin-bottom"
                    :cloud-module="cloudModule"
                    :active-workflow-states="workflow.details"
                    :default-workflow-states.sync="default_workflow_states"
                    @set-workflow-states="setWorkflowStates"
                    @add-state-to-workflow="addStateToWorkflow"
                    @set-workflow-state-name="setWorkflowStateName"
                />
                <form @submit="submitWorkflow">
                    <div class="columns">
                        <div class="column">
                            <span class="has-text-weight-bold">
                                Select a state to add follow ups
                            </span>
                            <div class="list is-hoverable">
                                <a 
                                    v-for="(detail, key) in workflow.details"
                                    :key="key"
                                    class="list-item"
                                    @click="selectWorkflowDetail(detail)"
                                    :class="{'is-active':selected_workflow_detail.workflow_state_id == detail.workflow_state_id}"
                                >
                                    <component-workflow-state-name
                                        :name="detail.workflow_state_name"
                                    />
                                    <button 
                                        v-if="detail.workflow_state_id != default_workflow_states.initial && detail.workflow_state_id != default_workflow_states.final"
                                        type="button"
                                        class="delete is-pulled-right"
                                        @click="deleteStateFromWorkflow(detail)"
                                    ></button>
                                </a>
                            </div>
                        </div>
                        <div class="column">
                            <label class="label">Select a follow up state to add</label>
                            <div class="columns">
                                <div class="column">
                                    <b-field>
                                        <div class="control is-expanded">
                                            <span class="select is-fullwidth is-empty">
                                                <select v-model="selected_workflow_state_id" @change="addFollowUpState">
                                                    <option
                                                        v-for="workflow_state in possibleFollowUpStates"
                                                        :value="workflow_state.id"
                                                        :key="workflow_state.id"
                                                        :hidden="workflow_state.id == null"
                                                        :disbled="workflow_state.id == null"  
                                                    >
                                                        <component-workflow-state-name
                                                            :name="workflow_state.name"
                                                            :initial="workflow_state.initial"
                                                            :final="workflow_state.final"
                                                        >
                                                        </component-workflow-state-name>
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
                                        Follow up States
                                    </span>
                                    <div class="list is-hoverable">
                                        <a v-for="(workflow_detail, key) in nextStatesOfSelectedWorkflowDetail" :key="key" class="list-item">
                                            <component-workflow-state-name
                                                :name="workflow_detail.workflow_state_name"
                                            />
                                            <button type="button" class="delete is-pulled-right" @click="deleteFollowUpState(workflow_detail)">
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
                                    <button class="button is-primary" type="submit">
                                        <span v-if="workflow_id">Update Workflow</span>
                                        <span v-else>Create Workflow</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                <hr>
                <component-workflow-chart
                    v-if="default_workflow_states.initial && default_workflow_states.final"
                    class="has-text-centered"
                    :cloud-module="cloudModule"
                    :workflow="workflow.details"
                    :rerender.sync="rerender_chart"
                    :workflow-state-initial-id="default_workflow_states.initial"
                    :workflow-state-final-id="default_workflow_states.final"
                />
            </div>
        </div>
    </section>
</template>
<style scoped>
.has-magin-bottom {
    margin-bottom: 0.6rem;
}
</style>
