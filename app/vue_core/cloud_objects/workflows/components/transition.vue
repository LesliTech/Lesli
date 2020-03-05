<script>
import componentStatusName from "./status-name.vue"
export default {
    components: {
        'component-status-name': componentStatusName
    },

    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        }
    },

    data() {
        return {
            transition_statuses: null,
            transition_status_id: null,
            module_name: null,
            object_name: null
        }
    },

    mounted() {
        this.setCloudParams()
        this.getWorkflowStateOptions()
    },

    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        getWorkflowStateOptions(){
            if(this.cloudId){
                let url = `/${this.module_name}/options/workflows/${this.object_name}/${this.cloudId}`
                this.http.get(url).then(result =>{
                    if (result.successful) {
                        if(result.data && result.data.length > 0){
                            this.transition_statuses = result.data
                            this.transition_status_id = result.data[0].workflow_detail_id
                        }else{
                            this.transition_statuses = []
                        }
                    } else {
                        this.alert(result.error.message, 'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        

        patchWorkflow(event){
            if(event){
                event.preventDefault()
            }

            let url = `/${this.object_utils.pluralize(this.cloudModule)}/${this.cloudId}`
            let data = {}
            data[this.object_name] = {}
            let detail_key = `cloud_${this.module_name}_workflow_statuses_id`
            data[this.object_name][detail_key] = this.transition_status_id
            
            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    let status = this.transition_statuses.filter (status => status.id == this.transition_status_id)[0]
                    this.bus.publish(`update:/${this.cloudModule}/workflow`, status)
                    if(status.final){
                        this.alert('This resource has been successfully closed', 'success')
                        this.$router.push(`/${this.cloudId}`)
                    }else{
                        this.getWorkflowStateOptions()
                        this.alert('The status of this resource has been successfully updated', 'success')
                    }
                } else {
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        cloudId(){
            this.getWorkflowStateOptions()
        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h4 class="card-header-title">
                Move to Another State
            </h4>
        </div>
        <div class="card-content">
            <form @submit="patchWorkflow">
                <div class="columns">
                    <div class="column is-9">
                        <b-select expanded v-model="transition_status_id" placeholder="Select a status">
                            <option
                                v-for="status in transition_statuses"
                                :key="status.id"
                                :value="status.id"
                            >
                                <component-status-name
                                    :name="status.name"
                                />
                            </option>
                        </b-select>
                    </div>
                    <div class="column is-3">
                        <b-button type="is-primary" native-type="submit">
                            Update
                        </b-button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
