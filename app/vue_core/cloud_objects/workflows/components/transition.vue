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

        

        patchStatus(status){

            let url = `/${this.object_utils.pluralize(this.cloudModule)}/${this.cloudId}`
            let data = {}
            data[this.object_name] = {}
            let detail_key = `cloud_${this.module_name}_workflow_statuses_id`
            data[this.object_name][detail_key] = status.id
            
            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    this.bus.publish(`patch:/${this.cloudModule}/status`, status)
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
    <div>
        <b-dropdown hoverable aria-role="list" position="is-bottom-left">
            <button class="button" slot="trigger">
                <span>Change status</span>
                <b-icon icon="chevron-down" size="is-small" />
            </button>
            <b-dropdown-item
                @click="patchStatus(status)"
                v-for="status in transition_statuses"
                :key="status.id"
                :value="status.id"
                aria-role="listitem"
            >
                <component-status-name
                    :name="status.name"
                />
            </b-dropdown-item>
        </b-dropdown>
    </div>
</template>
