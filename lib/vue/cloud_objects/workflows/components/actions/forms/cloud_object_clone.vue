<script>
export default {
    props: {
        workflowId: {
            required: true
        },

        translationsPath: {
            required: true,
            type: String
        },

        workflowAction: {
            required: true
        },

        options: {
            rquired: true
        },

        viewType: {
            type: String,
            default: 'new'
        },
        
        cloudEngine: {
            type: String,
            required: true
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            workflow_action: null,
            clone_options: {
                attributes: {},
                options: {}
            },
            cloud_engine: '',
            clone_available: true
        }
    },

    mounted(){
        this.setCloudEngine()
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getCloneOptions()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-clone-cloud-object`)
    },

    methods: {
        setCloudEngine(){
            if(this.cloudEngine == 'crm'){
                this.cloud_engine = 'house'
            }else{
                this.cloud_engine = this.cloudEngine
            }
        },

        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-clone-cloud-object`, (action, callback)=>{
                this.$set(action, 'template_path', this.workflow_action.template_path)
                this.$set(action, 'input_data', this.workflow_action.input_data)
                this.$set(action, 'system_data', this.workflow_action.system_data)
                this.$set(action, 'concerning_users', this.workflow_action.concerning_users)
                this.$set(action, 'configuration', this.workflow_action.configuration)
                if(callback){
                    callback()
                }
            })
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        cloneWorkflowAction(){
            this.workflow_action = JSON.parse(JSON.stringify(this.workflowAction))
        },

        getCloneOptions(){
            this.http.get(`/${this.cloud_engine}/workflows/${this.workflowId}/actions/resources/options_cloud_object_clone`).then(result => {
                if (result.successful) {
                    if(result.data){

                    }else{
                        this.clone_available = false
                    }
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        getUsers(){
            this.http.get('/users.json?role=kop,callcenter,api&type=exclude').then(result => {
                if (result.successful) {
                    this.$set(this.clone_options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    },

    computed: {
        filteredUsers(){
            return this.clone_options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.workflow_action.concerning_users.list[0].name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="has-text-centered" v-if="! clone_available">
            <input type="hidden" required>
            <i class="fas fa-exclamation-triangle fa-lg"></i>
            <br>
            <h4>This action is not available for this workflow</h4>
        </div>
    </section>
</template>
