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
        },
        handlePatch: {
            type: Boolean,
            default: true
        },
        value: {
            default: null
        },
        translationsPath: {
            type: String,
            default: null
        }
    },

    data() {
        return {
            core_translations: I18n.t('core.shared'),
            transition_statuses: null,
            module_name: null,
            object_name: null,
            selected_status_name: null
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
                        this.notification.alert(result.error.message, 'danger')
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
                        this.notification.alert('This resource has been successfully closed', 'success')
                        this.$router.push(`/${this.cloudId}`)
                    }else{
                        this.getWorkflowStateOptions()
                        this.notification.alert('The status of this resource has been successfully updated', 'success')
                    }
                } else {
                    this.notification.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        submitStatus(status){
            if(this.handlePatch){
                this.patchStatus(status)
            }else{
                this.$emit('input', status.id)
                this.selected_status_name = status.name
            }
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
                <span v-if="selected_status_name">{{core_translations.workflows_text_new_status}}: {{selected_status_name}}</span>
                <span v-else>{{core_translations.workflows_text_change_status}}</span>
                <b-icon icon="chevron-down" size="is-small" />
            </button>
            <b-dropdown-item
                @click="submitStatus(status)"
                v-for="status in transition_statuses"
                :key="status.id"
                :value="status.id"
                aria-role="listitem"
            >
                <component-status-name
                    :translations-path="translationsPath"
                    :name="status.name"
                />
            </b-dropdown-item>
        </b-dropdown>
    </div>
</template>
