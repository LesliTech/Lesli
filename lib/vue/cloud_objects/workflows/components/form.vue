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
import componentWorkflowChart from "LesliVue/cloud_objects/workflows/components/chart.vue"
import componentStatusName from "LesliVue/cloud_objects/workflows/components/status-name.vue"

export default {
    components: {
        'component-workflow-chart': componentWorkflowChart,
        'component-status-name': componentStatusName
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
            rerender_chart: false,
            workflow: null,
            workflow_id: null,
            selected_workflow_status: {},
            selected_workflow_status_number: null,
            deleted_workflow_statuses: [],
            new_status_name: '',
            statuses_count: 0
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
        },
        
        setWorkflowId(){
            if (this.$route.params.id) {
                this.workflow_id = this.$route.params.id
                this.getWorkflow()
            }else{
                this.workflow = {
                    name: '',
                    statuses: {
                        '0': {
                            name: 'created',
                            number: 0,
                            initial: true,
                            next_statuses: '1'
                        },
                        '1': {
                            name: 'closed',
                            number: 1,
                            final: true
                        }
                    }
                }
                this.statuses_count = 2;
            }
        },

        getWorkflow() {
            let url = `/${this.module_name}/workflows/${this.workflow_id}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow = result.data
                    this.statuses_count = this.workflow.next_number
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        addStatusToWorkflow() {
            let new_status = {
                next_statuses: '1',
                visited: false,
                number: this.statuses_count,
                name: this.new_status_name
            }

            this.statuses_count+=1

            this.workflow.statuses['0'].next_statuses+=`|${new_status.number}`
            this.$set(this.workflow.statuses, new_status.number, new_status)

            this.new_status_name = ''
            this.$refs['input-status-name'].focus()
            this.rerender_chart = true
        },

        deleteStatusFromWorkflow(deleted_status){

            let number = deleted_status.number
            this.$delete(this.workflow.statuses, number)
            if(deleted_status.id){
                deleted_status['_destroy'] = true
                this.deleted_workflow_statuses.push(deleted_status)
            }

            for(let status_number in this.workflow.statuses){
                let workflow_status = this.workflow.statuses[status_number]

                if(workflow_status.next_statuses){
                    workflow_status.next_statuses = workflow_status.next_statuses.replace(
                        new RegExp(`([^0-9]${number}$)|(^${number}[^0-9])|(^${number}$)`,'g'), ''
                    ).replace(
                        new RegExp(`([^0-9]${number}[^0-9])`,'g'), '|'
                    )
                    if(workflow_status.next_statuses.length == 0){
                        workflow_status.next_statuses = null
                    }
                }
            }
            this.rerender_chart = true
        },

        addFollowUpStatus(){
            if(this.selected_workflow_status_number){
                if(this.selected_workflow_status.next_statuses){
                    this.selected_workflow_status.next_statuses += `|${this.selected_workflow_status_number}`
                }else{
                    this.selected_workflow_status.next_statuses = `${this.selected_workflow_status_number}`
                }
                this.selected_workflow_status_number = null
                this.rerender_chart = true
            }
        },
        
        selectWorkflowStatus(workflow_status){
            this.selected_workflow_status = workflow_status
        },

        deleteFollowUpStatus(workflow_status){

            let number = workflow_status.number

            this.selected_workflow_status.next_statuses = this.selected_workflow_status.next_statuses.replace(
                new RegExp(`([^0-9]${number}$)|(^${number}[^0-9])|(^${number}$)`,'g'), ''
            ).replace(
                new RegExp(`([^0-9]${number}[^0-9])`,'g'), '|'
            )
            this.rerender_chart = true
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
                let statuses_attributes = Object.values(this.workflow.statuses)
                
                let data = {
                    workflow: {
                        name: this.workflow.name,
                        statuses_attributes: statuses_attributes
                    }
                }
                let url = `/${this.module_name}/workflows`

                this.http.post(url, data).then(result => {
                    if (result.successful) {
                        this.notification.alert('Workflow created successfully', 'success')
                        
                        this.workflow = result.data
                        this.$router.push(`/${result.data.id}`)
                    }else{
                        this.notification.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }else{
                this.$refs['input-workflow-name'].focus()
                this.notification.alert('Please provide a name for this workflow','danger')
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
            let url = `/${this.module_name}/workflows/${this.workflow_id}`

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.notification.alert('Workflow updated successfully', 'success')

                    this.$router.push(`/${this.workflow.id}`)
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowName(){
            if(this.workflow_id){
                
                let data = {
                    workflow: {
                        name: this.workflow.name
                    }
                }
                let url = `/${this.module_name}/workflows/${this.workflow_id}`

                this.http.patch(url, data).then(result => {
                    if (result.successful) {
                        this.notification.alert('Workflow name successfully updated', 'success')
                    }else{
                        this.notification.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    },

    computed: {
        
        nextStatusesOfSelectedStatus(){
            let next_statuses = []
            if(! this.workflow.statuses[this.selected_workflow_status.number]){
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

        possibleFollowUpStatuses(){
            let label = [{number: null, name: 'Select a follow up state to add'}]

            if( ! this.selected_workflow_status.next_statuses || this.selected_workflow_status.final ){
                return label
            }
            
            let follow_up_statuses  = this.selected_workflow_status.next_statuses.split('|').map((element)=>{
                return parseInt(element)
            })

            return label.concat(Object.values(this.workflow.statuses).filter(element => {
                return ! ( follow_up_statuses.includes(element.number) || element.initial) 
            }))
        }
    }
}
</script>
<template>
    <div class="card" v-if="workflow">
        <div class="card-header">
            <h2 class="card-header-title">
                Workflow
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
            <div class="columns">
                <div class="column is-8">
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
                </div>
                <div class="column is-4">
                    <b-field label="Add a new state to the workflow">
                        <b-input v-model="new_status_name" @change.native="addStatusToWorkflow" ref="input-status-name">
                        </b-input>
                    </b-field>
                </div>
            </div>
            <hr>
            <form @submit="submitWorkflow">
                <div class="columns">
                    <div class="column">
                        <span class="has-text-weight-bold">
                            Select a state to add follow ups
                        </span>
                        <div class="list is-hoverable">
                            <a 
                                v-for="(status, key) in workflow.statuses"
                                :key="key"
                                class="list-item"
                                @click="selectWorkflowStatus(status)"
                                :class="{'is-active':selected_workflow_status.number == status.number}"
                            >
                                <component-status-name
                                    :name="status.name"
                                />
                                <button 
                                    v-if="! status.initial && ! status.final"
                                    type="button"
                                    class="delete is-pulled-right"
                                    @click="deleteStatusFromWorkflow(status)"
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
                                            <select v-model="selected_workflow_status_number" @change="addFollowUpStatus">
                                                <option
                                                    v-for="workflow_status in possibleFollowUpStatuses"
                                                    :value="workflow_status.number"
                                                    :key="workflow_status.number"
                                                    :hidden="workflow_status.number == null"
                                                    :disbled="workflow_status.number == null"  
                                                >
                                                    <component-status-name
                                                        :name="workflow_status.name"
                                                        :initial="workflow_status.initial"
                                                        :final="workflow_status.final"
                                                    >
                                                    </component-status-name>
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
                                    <a v-for="(workflow_status, key) in nextStatusesOfSelectedStatus" :key="key" class="list-item">
                                        <component-status-name
                                            :name="workflow_status.name"
                                        />
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
                class="has-text-centered"
                :cloud-module="cloudModule"
                :workflow="workflow"
                :rerender.sync="rerender_chart"
            />
        </div>
    </div>
</template>
