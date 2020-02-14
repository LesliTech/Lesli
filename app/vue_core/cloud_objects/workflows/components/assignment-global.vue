<script>
export default {
    props: {
        cloudEngine: {
            type: String,
            required: true
        },
        workflowId: {
            required: true
        }
    },

    data(){
        return {
            show: false,
            global_assignments: [],
            module_name: '',
            options_endpoint: '',
            workflow_assignment: []
        }
    },

    mounted(){
        this.setEndpoints()
        this.mountSubscriptions()
        this.getGlobalAssignments()

    },

    methods: {
        setEndpoints(){
            this.options_endpoint = `/${this.module_name}/options/workflow_assignments`
        },

        mountSubscriptions(){
            this.bus.subscribe('show:/module/workflows/assignment-global', () => {
                this.show = ! this.show
            })
        },

        patchWorkflowAssignment(workflow_assignment){
            let url = `/${this.module_name}/${this.object_name}_workflows/${workflow_assignment.id}`
            let data = {}
            data[`${this.object_name}_workflow`] =  workflow_assignment
            
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

        getGlobalAssignments(){
            let url = `/${this.cloudEngine}/options/workflows/${this.workflowId}`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.global_assignments = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        submitGlobalAssignment(assignment){
            if(assignment.id){
                if(assignment.assigned){
                    this.patchGlobalAssignment(assignment)
                }else{
                    this.deleteGlobalAssignment(assignment)
                }
            }else{
                this.postGlobalAssignment(assignment)
            }
        },

        postGlobalAssignment(assignment){
            let data = {}
            data[assignment.params_name] = {}
            data[assignment.params_name][`cloud_${this.cloudEngine}_workflows_id`] = this.workflowId

            this.http.post(assignment.url, data).then(result => {
                if (result.successful) {
                    assignment.id = result.data.id
                    this.alert(`This workflow has been successfully assigned to ${assignment.name.toLowerCase()}`, 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        patchGlobalAssignment(assignment){
            let data = {}
            data[assignment.params_name] = {}
            data[assignment.params_name][`cloud_${this.cloudEngine}_workflows_id`] = this.workflowId

            this.http.patch(`${assignment.url}/${assignment.id}`, data).then(result => {
                if (result.successful) {
                    this.alert(`This workflow has been successfully assigned to ${assignment.name.toLowerCase()}`, 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteGlobalAssignment(assignment){
            this.http.delete(`${assignment.url}/${assignment.id}`).then(result => {
                if (result.successful) {
                    delete assignment.id 
                    this.alert(`This workflow has been successfully unassigned from ${assignment.name.toLowerCase()}`, 'success')
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
                <p class="title">Assign this workflow to...</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <ul class="menu-list">
                            <li class="field" v-for="(assignment, index) in global_assignments" :key="`assignment-${index}`">
                                <input
                                    :id="`assignment-${index}`"
                                    class="is-checkradio"
                                    type="checkbox"
                                    v-model="assignment.assigned"
                                    @change="submitGlobalAssignment(assignment)"
                                >
                                <label :for="`assignment-${index}`">{{ assignment.name }}</label>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
            </footer>
        </div>
    </section>
</template>
