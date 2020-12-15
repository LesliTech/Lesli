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

        engineNamespace: {
            type: String,
            required: true
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared'),
                actions: I18n.t('core.workflow/actions'),
                bell: I18n.t('bell.notifications')
            },
            workflow_action: null,
            file_options: {
                templates: {},
                file_types: []
            },
            action_unavailable: false
        }
    },

    mounted(){
        this.setMainRoute()
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getCloudObjectFileOptions()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-create_cloud_object_file`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-create_cloud_object_file`, (action, callback)=>{
                this.$set(action, 'template_path', this.workflow_action.template_path)
                this.$set(action, 'input_data', this.workflow_action.input_data)
                this.$set(action, 'system_data', this.workflow_action.system_data)
                this.$set(action, 'configuration', this.workflow_action.configuration)
                if(callback){
                    callback()
                }
            })
        },

        setMainRoute(){
            if(this.engineNamespace == 'crm'){
                this.main_route = '/house/workflows'
            }else if(this.engineNamespace == '/'){
                this.main_route = '/workflows'
            }else{
                this.main_route = `/${this.engineNamespace}/workflows`
            }
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
            
        },

        cloneWorkflowAction(){
            this.workflow_action = JSON.parse(JSON.stringify(this.workflowAction))
        },

        getCloudObjectFileOptions(){
            let url = `${this.main_route}/${this.workflowId}/actions/resources/options_create_cloud_object_file.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    if(result.data && result.data.templates.length > 0){
                        this.file_options = result.data
                    }else{
                        this.action_unavailable = true
                    }
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="has-text-centered" v-if="action_unavailable">
            <i class="fas fa-exclamation-triangle fa-lg"></i>
            <br>
            {{translations.actions.view_text_no_templates_available}}
        </div>
        <div v-else>
            <div class="field">
                <label class="label">{{translations.actions.column_template}}<sup class="has-text-danger">*</sup></label>
                <b-select :placeholder="translations.actions.view_placeholder_template" expanded v-model="workflow_action.input_data.template_id" required>
                    <option
                        v-for="template in file_options.templates"
                        :value="template.id"
                        :key="template.id"
                    >
                        <small>{{template.name}}</small>
                    </option>
                </b-select>
            </div>
            <div class="field">
                <label class="label">{{translations.actions.column_file_type}}<sup class="has-text-danger">*</sup></label>
                <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="workflow_action.input_data.file_type" required>
                    <option
                        v-for="file_type in file_options.file_types"
                        :value="file_type.value"
                        :key="file_type.value"
                    >
                        <small>{{file_type.text}}</small>
                    </option>
                </b-select>
            </div>
        </div>
    </section>
</template>
