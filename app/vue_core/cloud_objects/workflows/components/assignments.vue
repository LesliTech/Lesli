<script>
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudAssociationId: {
            required: true
        },
        workflowKeyName: {
            type: String,
            required: true
        }
    },

    data(){
        return {
            show: false,
            workflow_assignments: [],
            workflow_associations: [],
            workflows: [],
            module_name: null,
            object_name: null
        }
    },

    mounted(){
        this.setCloudParams()
        this.mountListeners()
        this.getWorkflowAssociations()
        this.getWorkflowAssignments()
        this.getWorkflows()

    },

    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        mountListeners(){
            this.bus.subscribe('show:/module/app/workflow-assignments', () => {
                this.show = ! this.show
            })
        },

        getWorkflows(){
            let url = `/${this.module_name}/${this.object_name}_workflows.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflows = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getWorkflowAssignments(){
            let query = `name=${this.object_name}_${this.workflowKeyName}&resource_id=${this.cloudAssociationId}`
            let url = `/${this.module_name}/${this.object_name}_workflow_assignments.json?${query}`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow_assignments = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchWorkflowAssignment(workflow_assignment){
            let url = `/${this.module_name}/${this.object_name}_workflow_assignments/${workflow_assignment.id}`
            let data = {}
            data[`${this.object_name}_workflow_assignment`] =  workflow_assignment
            
            this.http.patch(url, data).then(result => {
                if (result.successful) {
                    this.alert('Workflow Assignment successfully updated', 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getWorkflowAssociations(){
            let url = `/${this.module_name}/options/${this.object_name}_workflow_assignments`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.workflow_associations = result.data.filter((association)=>{
                        return association.name != `${this.object_name}_${this.workflowKeyName}`
                    })
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
    <section>
        <div :class="[{ 'is-active': show }, 'quickview']">
            <header class="quickview-header" @click="show = false">
                <p class="title">Assign a Workflow</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <b-table
                            :data="workflow_assignments"
                        >
                            <template v-slot="props">
                                <b-table-column
                                    :field="`cloud_${module_name}_${object_name}_workflows_id`"
                                    label="Workflow Name"
                                >
                                    <div class="control is-expanded">
                                        <span class="select is-fullwidth">
                                            <select
                                                expanded
                                                v-model="props.row[`cloud_${module_name}_${object_name}_workflows_id`]"
                                                @change="patchWorkflowAssignment(props.row)"
                                            >
                                                <option
                                                    v-for="workflow in workflows"
                                                    :value="workflow.id"
                                                    :key="workflow.id">
                                                    {{ workflow.name }}
                                                </option>
                                            </select>
                                        </span>
                                    </div>
                                </b-table-column>
                                <b-table-column
                                    v-for="association in workflow_associations"
                                    :key="association.name"
                                    :field="`${association.name}_${association.identifier}`"
                                    :label="`${association.name}_${association.identifier}`"
                                >
                                    {{props.row[`${association.name}_${association.identifier}`]}}
                                </b-table-column>
                            </template>
                        </b-table>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
            </footer>
        </div>
    </section>
</template>
