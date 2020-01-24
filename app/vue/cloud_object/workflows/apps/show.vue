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
import componentWorkflowChart from "LesliCloud/vue/cloud_object/workflows/components/chart.vue"

export default {
    props: {
        cloudModule: {
            type: String,
            default: 'help'
        },
        cloudObject: {
            type: String,
            default: 'ticket'
        }
    },

    components: {
        'component-workflow-chart': componentWorkflowChart
    },
    data() {
        return {
            translations: {
                shared: I18n.t('cloud_help.ticket_workflows.shared'),
                show: I18n.t('cloud_help.ticket_workflows.show')
            },
            modal: {
                active: false
            },
            ticket_workflow: {},
            ticket_workflow_id: null,
            default_workflow_states: null
        }
    },
    mounted() {
        // · setWorkflowId() calls getWorkflow()
        this.setWorkflowId()
        this.getWorkflowStates()
    },
    methods: {
        
        setWorkflowId(){
            if (this.$route.params.id) {
                this.ticket_workflow_id = this.$route.params.id
                this.getWorkflow()
            }
        },

        getWorkflow() {
            this.http.get(`/help/ticket_workflows/${this.ticket_workflow_id}.json`).then(result => {
                if (result.successful) {
                    this.ticket_workflow = result.data
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getWorkflowStates(){
            this.http.get(`/${this.cloudModule}_workflow_states.json`).then(result => {
                if (result.successful) {

                    let initial_state = result.data.filter( state => state.initial)[0]
                    let final_state = result.data.filter( state => state.final)[0]

                    this.default_workflow_states = {
                        initial: initial_state.id,
                        final: final_state.id
                    }
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowDefault() {
            let data = {
                ticket_workflow: {
                    default: true
                }
            }
            this.http.patch(`/help/ticket_workflows/${this.ticket_workflow_id}`, data).then(result => {
                if(result.successful){
                    this.ticket_workflow.default = true
                    this.alert(this.translations.show.messages.set_as_default, 'success')
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteWorkflow(){
            this.modal.active = false
            this.http.delete(`/help/ticket_workflows/${this.ticket_workflow_id}`).then(result => {
                if(result.successful){
                    this.alert(this.translations.show.messages.delete,'success')
                    this.$router.push('/')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section v-if="ticket_workflow && default_workflow_states">
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
                        {{ translations.show.modal.title }}
                    </h2>
                </div>
                <div class="card-content">
                    {{ translations.show.modal.body }}
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-danger" @click="deleteWorkflow">
                        {{ translations.show.modal.actions.delete }}
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.active=false">
                        {{ translations.show.modal.actions.cancel }}
                    </button>
                </div>
            </div>
        </b-modal>
        <div class="card">
            <div class="card-header">
                <h2 class="card-header-title">
                    {{ ticket_workflow.name }} &nbsp;
                    <span v-if="ticket_workflow.default" class="has-text-info">
                        ({{translations.shared.fields.default}})
                    </span>
                </h2>
                <div class="card-header-icon">
                    <span v-if="ticket_workflow.default" class="has-text-gray">
                        <i class="fas fa-check-circle"></i>
                        {{ translations.shared.actions.set_as_default}}
                    </span>
                    <a v-else href="javascript:void(0)" @click="patchWorkflowDefault">
                        <i class="fas fa-check-circle"></i>
                        {{ translations.shared.actions.set_as_default}}
                    </a>
                    <router-link :to="`/${ticket_workflow_id}/edit`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-edit"></i>
                        {{ translations.shared.actions.edit }}
                    </router-link>
                    <router-link :to="`/`">
                        &nbsp;&nbsp;&nbsp;
                        <i class="fas fa-undo"></i>
                        {{ translations.shared.actions.return }}
                    </router-link>
                </div>
            </div>
            <div class="card-content">
                <component-workflow-chart
                    class="has-text-centered"
                    cloud-module="help/ticket"
                    :workflow="ticket_workflow.details"
                    :workflow-state-initial-id="default_workflow_states.initial"
                    :workflow-state-final-id="default_workflow_states.final"
                >
                </component-workflow-chart>
                <div class="columns">
                    <div class="column">
                        <small>
                            <span class="has-text-weight-bold">
                                {{ `${translations.shared.fields.created_at}:` }}
                            </span>
                            {{ date.toLocalFormat(ticket_workflow.created_at, false, true) }}
                            <br>
                            <span class="has-text-weight-bold">
                                {{ `${translations.shared.fields.updated_at}:` }}
                            </span>
                            {{ date.toLocalFormat(ticket_workflow.updated_at, false, true) }}
                        </small>
                    </div>
                    <div class="column">
                        <div class="field">
                            <div class="actions has-text-right">
                                <button class="button is-danger" @click="modal.active = true">
                                    {{ translations.shared.actions.delete }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
