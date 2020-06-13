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
import componentChart from '../components/chart.vue'
import componentAssociation from '../components/association.vue'

export default {
    
    // @component_prop CloudModule [String] The cloud module that imported this component.
    //      For example, 'house/property'. It helps determine the endpoints to which this 
    //      and child components connect to
    props: {
        cloudModule: {
            type: String,
            required: true
        }
    },

    components: {
        'component-chart': componentChart,
        'component-association': componentAssociation
    },

    data() {
        return {
            module_name: null,
            modal: {
                active: false
            },
            workflow: null,
            workflow_id: null
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
            }
        },

        getWorkflow() {
            this.http.get(`/${this.module_name}/workflows/${this.workflow_id}.json`).then(result => {
                if (result.successful) {
                    this.workflow = result.data
                } else {
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        publishShowWorkflowAssociation(){
            this.bus.publish('show:/module/workflows/association')
        },

        patchWorkflowDefault() {
            let data = {
                workflow: {
                    default: true
                }
            }

            this.http.patch(`/${this.module_name}/workflows/${this.workflow_id}`, data).then(result => {
                if(result.successful){
                    this.workflow.default = true
                    this.notification.alert('Workflow set as default successfully', 'success')
                } else {
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteWorkflow(){
            this.modal.active = false
            this.http.delete(`/${this.module_name}/workflows/${this.workflow_id}`).then(result => {
                if(result.successful){
                    this.notification.alert('Workflow successfully deleted', 'success')
                    this.$router.push('/')
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow" class="section">
        <b-modal 
            :active.sync="modal.active"
            has-modal-card
            trap-focus
            aria-role="dialog"
            aria-modal
        >
            <div class="card">
                <div class="card-header is-danger">
                    <h2 class="card-header-title">
                        Are you sure you want to delete this workflow?
                    </h2>
                </div>
                <div class="card-content">
                    Once deleted, you will not be able to recover this workflow.
                    Note that you can only delete a workflow if it is not associated to any resource and it is not the default workflow.
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-danger" @click="deleteWorkflow">
                        Yes, delete it
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.active=false">
                        Cancel
                    </button>
                </div>
            </div>
        </b-modal>
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    {{ workflow.name }} &nbsp;
                    <span v-if="workflow.default" class="has-text-info">
                        (Default)
                    </span>
                </h2>
                <div class="card-header-icon">
                    <span v-if="workflow.default" class="has-text-gray">
                        <i class="fas fa-check-circle"></i>
                        Set as Default
                    </span>
                    <a v-else href="javascript:void(0)" @click="patchWorkflowDefault">
                        <i class="fas fa-check-circle"></i>
                        Set as Default
                    </a>
                    <a role="button" @click="publishShowWorkflowAssociation">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-globe"></i>
                        Associations
                    </a>
                    <router-link :to="`/${workflow_id}/edit`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-edit"></i>
                        Edit Workflow
                    </router-link>
                    <router-link :to="`/`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-undo"></i>
                        Return
                    </router-link>
                </div>
            </div>
            <div class="card-content">
                <component-chart
                    class="has-text-centered"
                    :cloud-module="cloudModule"
                    :workflow="workflow"
                >
                </component-chart>
                <div class="columns">
                    <div class="column">
                        <small>
                            <span class="has-text-weight-bold">
                                Created at:
                            </span>
                            {{ date.toLocalFormat(workflow.created_at, false, true) }}
                            <br>
                            <span class="has-text-weight-bold">
                                Updated at:
                            </span>
                            {{ date.toLocalFormat(workflow.updated_at, false, true) }}
                        </small>
                    </div>
                    <div class="column">
                        <div class="field">
                            <div class="actions has-text-right">
                                <button class="button is-danger" @click="modal.active = true">
                                    Delete workflow
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <component-association :cloud-engine="module_name" :workflow-id="workflow_id" />
    </section>
</template>
