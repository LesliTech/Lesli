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
            object_name: null
        }
    },

    mounted() {
        this.setCloudParams()
        this.setSubscriptions()
        this.getTransitionOptions()
    },

    beforeDestroy(){
        this.bus.$off('cancel:/status-change')
        this.bus.$off('execute:/status-change')
    },

    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
            this.object_name = module_data[1]
        },

        setSubscriptions(){
            this.bus.subscribe('cancel:/status-change', ()=>{
                this.$emit('input', null)
            })

            this.bus.subscribe('execute:/status-change', (status, callback)=>{
                this.patchStatus(status, callback)
            })
        },

        getTransitionOptions(){
            if(this.cloudId){
                let url = `/${this.module_name}/workflows/resources/transition-options/${this.object_name}/${this.cloudId}.json`
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

        

        patchStatus(status, callback){

            let module_name = this.module_name
            if(module_name == 'crm'){
                module_name = 'house'
            }

            let url = `/${this.object_utils.pluralize(this.cloudModule)}/${this.cloudId}`
            let data = {}
            data[this.object_name] = {}
            let detail_key = `cloud_${module_name}_workflow_statuses_id`
            data[this.object_name][detail_key] = status.id
            
            this.http.patch(url, data).then(result =>{
                if (result.successful) {
                    this.bus.publish(`patch:/${this.cloudModule}/status`, status)
                    if(callback){
                        callback()
                    }
                    if(status.final){
                        this.alert('This resource has been successfully closed', 'success')
                        this.$router.push(`/${this.cloudId}`)
                    }else{
                        this.getTransitionOptions()
                        this.alert(this.core_translations.status_updated, 'success')
                    }
                } else {
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        submitStatus(status){
            if(this.handlePatch){
                this.patchStatus(status)
            }else{
                this.$emit('input', status)
            }
        }
    },

    watch: {
        cloudId(){
            this.getTransitionOptions()
        }
    }
}
</script>
<template>
    <div>
        <b-dropdown hoverable aria-role="list" position="is-bottom-left">
            <button class="button" slot="trigger" type="button">
                <span v-if="value">
                    {{core_translations.workflows_text_new_status}}:
                    <component-status-name
                        :translations-path="translationsPath"
                        :name="value.name"
                    />
                </span>
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
