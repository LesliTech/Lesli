<script>
import componentWorkflowStateName from "../../workflow_states/components/name.vue"
export default {
    components: {
        'component-workflow-state-name': componentWorkflowStateName
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
            transition_states: null,
            transition_detail_id: null,
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
                let url = `/${this.module_name}/options/${this.object_name}s/${this.cloudId}/workflows`
                this.http.get(url).then(result =>{
                    if (result.successful) {
                        if(result.data && result.data.length > 0){
                            this.transition_states = result.data
                            this.transition_detail_id = result.data[0].workflow_detail_id
                        }else{
                            this.transition_states = []
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

            let url = `/${this.cloudModule}s/${this.cloudId}`
            let data = {}
            data[this.object_name] = {
                detail_attributes: {}
            }
            let detail_key = `cloud_${this.module_name}_${this.object_name}_workflow_details_id`
            data[this.object_name].detail_attributes[detail_key] = this.transition_detail_id
            
            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    let state = this.transition_states.filter (state => state.workflow_detail_id == this.transition_detail_id)[0]
                    this.bus.publish(`update:/${this.cloudModule}/workflow`, state)
                    if(state.final){
                        this.alert('This resource is now closed has been successfully closed', 'success')
                        this.$router.push(`/${this.cloudId}`)
                    }else{
                        this.getWorkflowStateOptions()

                        this.alert('The state of this resource has been successfully updated', 'success')
                        this.$emit('update-workflow', state)
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
                        <b-select expanded v-model="transition_detail_id">
                            <option
                                v-for="state in transition_states"
                                :key="state.workflow_detail_id"
                                :value="state.workflow_detail_id"
                            >
                                <component-workflow-state-name
                                    :name="state.name"
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
