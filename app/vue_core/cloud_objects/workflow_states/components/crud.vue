<script>


import componentWorkflowStateName from './name.vue'

export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        defaultWorkflowStates: {
            type: Object,
            required: true
        },
        activeWorkflowStates: {
            type: Object,
            required: true
        }
    },

    components: {
        'component-workflow-state-name': componentWorkflowStateName
    },

    data(){
        return {
            modal: {
                delete: {
                    active: false
                },
                edit: {
                    active: false
                }
            },
            workflow_states: null,
            new_workflow_state: {
                name: ''
            },
            selected_workflow_state: {
                name: ''
            }
        }
    },

    mounted(){
        this.setCloudParams()
        this.getWorkflowStates()
    },

    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        getWorkflowStates(){
            this.http.get(`/${this.module_name}/workflow_states.json`).then(result => {
                if (result.successful) {
                    this.workflow_states = result.data

                    let initial_state = this.workflow_states.filter( state => state.initial)[0]
                    let final_state = this.workflow_states.filter( state => state.final)[0]

                    let default_workflow_states = {
                        initial: initial_state.id,
                        final: final_state.id
                    }
                    this.$emit('update:default-workflow-states', default_workflow_states)
                    this.$emit('set-workflow-states', result.data)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postWorkflowState(event){
            event.preventDefault()

            let data = {
                workflow_state: {
                    ... this.new_workflow_state
                }
            }
            this.new_workflow_state.name = ''
            this.http.post(`/${this.module_name}/workflow_states`, data).then(result => {
                if (result.successful) {
                    this.getWorkflowStates()
                    this.alert('Workflow state created successfully', 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowState(event){
            event.preventDefault()
            this.modal.edit.active = false
            let data = {
                workflow_state: this.selected_workflow_state
            }
            let url = `/${this.module_name}/workflow_states/${this.selected_workflow_state.id}`
            
            this.http.patch(url, data).then(result => {
                if (result.successful) {
                    this.$emit('set-workflow-state-name', this.selected_workflow_state)
                    this.getWorkflowStates()
                    this.alert('Workflow state updated successfully', 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteWorkflowState(){
            this.modal.delete.active = false
            if(this.selected_workflow_state){
                let url = `/${this.module_name}/workflow_states/${this.selected_workflow_state.id}`
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.getWorkflowStates()
                        this.alert('Workflow state deleted successfully', 'success')
                    }else{
                        this.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        showDeleteModal(workflow_state){
            this.selected_workflow_state = workflow_state
            this.modal.delete.active = true
        },

        showEditModal(workflow_state){
            this.selected_workflow_state = { ...workflow_state}
            this.modal.edit.active = true
            this.$nextTick(function(){
                this.$refs['input-workflow-state-name'].focus()
            })
        },

        emitAddStateToWorkflow(workflow_state){
            this.$emit('add-state-to-workflow', workflow_state)
        }
    }
}
</script>
<template>
    <section v-if="workflow_states">
        <b-modal
            :active.sync="modal.edit.active"
            has-modal-card
            trap-focus
            aria-role="dialog"
            aria-modal
        >
            <div class="card">
                <div class="card-header is-danger">
                    <h2 class="card-header-title">
                        Edit Workflow State
                    </h2>
                </div>
                <div class="card-content">
                    <form @submit="patchWorkflowState" id="form-edit-workflow-state">
                        <b-field label="Name">
                            <b-input
                                ref="input-workflow-state-name"
                                v-model="selected_workflow_state.name"
                                type="text"
                                required
                            />
                        </b-field>
                    </form>
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-primary" type="submit" form="form-edit-workflow-state">
                        Save changes
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.delete.active=false">
                        Cancel
                    </button>
                </div>
            </div>
        </b-modal>
        <b-modal 
            :active.sync="modal.delete.active"
            has-modal-card
            trap-focus
            aria-role="dialog"
            aria-modal
        >
            <div class="card">
                <div class="card-header is-danger">
                    <h2 class="card-header-title">
                        Are you sure you want to delete this workflow state?
                    </h2>
                </div>
                <div class="card-content">
                    You will only be able to delete it if there are no workflows currently associated with it.
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-danger" @click="deleteWorkflowState">
                        Yes, delete it
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.delete.active=false">
                        Cancel
                    </button>
                </div>
            </div>
        </b-modal>
        <div class="columns">
            <div class="column is-9">
                <span v-for="workflow_state in workflow_states" :key="workflow_state.id">
                    <span
                        class="tag is-medium has-margin-top" 
                        v-bind:class="{'is-success': activeWorkflowStates[workflow_state.id] != null}"
                    >
                        <component-workflow-state-name
                            :name="workflow_state.name"
                        />
                        <span v-if="! workflow_state.initial && ! workflow_state.final">
                            <b-tooltip
                                label="Add to Workflow"
                                type="is-primary"
                            >
                                <a
                                    v-if="activeWorkflowStates[workflow_state.id] == null"
                                    size="is-small"
                                    role="button"
                                    @click="emitAddStateToWorkflow(workflow_state)"
                                >
                                    &nbsp;&nbsp;<b-icon icon="plus-circle" size="is-small"></b-icon>&nbsp;&nbsp;
                                </a>
                            </b-tooltip>
                            <b-tooltip label="Edit Name" type="is-black">
                                <a size="is-small" role="button" @click="showEditModal(workflow_state)">
                                    &nbsp;&nbsp;<b-icon icon="edit" size="is-small" type="is-black"></b-icon>&nbsp;&nbsp;
                                </a>
                            </b-tooltip>
                            <b-tooltip
                                label="Delete State"
                                type="is-danger"
                                v-if="activeWorkflowStates[workflow_state.id] == null"
                            >
                                <a size="is-small" role="button" @click="showDeleteModal(workflow_state)">
                                    &nbsp;&nbsp;<b-icon icon="trash" type="is-danger" size="is-small"></b-icon>&nbsp;&nbsp;
                                </a>
                            </b-tooltip>
                        </span>
                    </span> &nbsp;
                </span>
            </div>
            <div class="column is-3">
                <form @submit="postWorkflowState">
                    <b-field>
                        <b-input v-model="new_workflow_state.name" placeholder="Add a new state" expanded required/>
                    </b-field>
                </form>
            </div>
        </div>
    </section>
    <section v-else class="has-text-centered">
        <b-icon
            type="is-primary"
            icon="spinner"
            size="is-large"
            custom-class="fa-spin"
        >
        </b-icon>
    </section>
</template>
<style scoped>
.has-margin-top {
    margin-top: 0.4rem;
}
</style>
