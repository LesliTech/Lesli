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
            main_route: null,
            translations: {
                core: I18n.t('core.shared'),
                actions: I18n.t('core.workflow/actions')
            },
            workflow_action: null,
            clone_options: {
                main_attributes: {},
                detail_attributes: {},
                cloud_object_options: {}
            },
            action_unavailable: false
        }
    },

    mounted(){
        this.setMainRoute()
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getCloneOptions()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-cloud_object_clone`)
    },

    methods: {
        setMainRoute(){
            if(this.engineNamespace == 'crm'){
                this.main_route = '/house/workflows'
            }else if(this.engineNamespace == '/'){
                this.main_route = '/workflows'
            }else{
                this.main_route = `/${this.engineNamespace}/workflows`
            }
        },

        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-cloud_object_clone`, (action, callback)=>{
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
            let url = `${this.main_route}/${this.workflowId}/actions/resources/options_cloud_object_clone.json`
            this.http.get(url).then(result => {
                if (result.successful) {
                    if(result.data){
                        for(let key in result.data){
                            this.$set(this.clone_options, key, result.data[key])
                        }
                    }else{
                        this.action_unavailable = true
                    }
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        getUsers(){
            this.http.get('/administration/users/list.json?role=kop,callcenter,api,support&type=exclude').then(result => {
                if (result.successful) {
                    this.$set(this.options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    },

    computed: {
        filteredUsers(){
            if(! this.options.users){
                return []
            }
            
            return this.options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.workflow_action.concerning_users.list[0].name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="has-text-centered" v-if="action_unavailable">
            <input type="hidden" required>
            <i class="fas fa-exclamation-triangle fa-lg"></i>
            <br>
            <h4>{{translations.actions.messages_warning_action_unavailable}}</h4>
        </div>
        <div v-else>
            <div class="columns">
                <div class="column is-5">
                    <label class="label">{{translations.actions.view_title_assign_resource_to}}<sup class="has-text-danger">*</sup></label>
                    <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="workflow_action.concerning_users.type" required>
                        <option
                            v-for="concerning_user_type in options.concerning_user_types"
                            :value="concerning_user_type.value"
                            :key="concerning_user_type.value"
                        >
                            <small>
                                {{ object_utils.translateEnum(translations.actions, 'column_enum_concerning_user_types', concerning_user_type.text) }}
                            </small>
                        </option>
                    </b-select>
                    <p v-if="workflow_action.concerning_users.type == 'reviewer' || workflow_action.concerning_users.type == 'branch_office'" class="help">
                        {{translations.actions.view_text_concerning_user_can_be_unavailable}}
                    </p>
                </div>
                <div class="column is-7">
                    <div class="field" v-if="workflow_action.concerning_users.type == 'custom'">
                        <label class="label">{{translations.actions.view_title_employee}}<sup class="has-text-danger">*</sup></label>
                        <div class="control">
                            <b-autocomplete
                                :placeholder="translations.actions.view_placeholder_select_employee"
                                v-model="workflow_action.concerning_users.list[0].name"
                                required
                                field="name"
                                @select="user => workflow_action.concerning_users.list[0].id = user.id"
                                :data="filteredUsers"
                            >
                            </b-autocomplete>
                        </div>
                    </div>
                </div>
            </div>

            <div class="field">
                <label class="label">
                    {{translations.actions.view_text_add_reference_to_resource}}
                    <sup class="has-text-danger">*</sup>
                </label>
                <div class="block">
                    <b-radio
                        size="is-small"
                        v-model="workflow_action.input_data.add_reference"
                        :native-value="true"
                    >
                        {{translations.core.view_text_yes}}
                    </b-radio>
                    <b-radio
                        size="is-small"
                        v-model="workflow_action.input_data.add_reference"
                        :native-value="false"
                    >
                        {{translations.core.view_text_no}}
                    </b-radio>
                </div>
            </div>

            <div class="columns" v-for="main_attribute in clone_options.main_attributes" :key="main_attribute.column">
                <div class="column is-5">
                    <div class="field">
                        <label class="label">
                            {{main_attribute.label}}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="workflow_action.input_data[main_attribute.column]" required>
                            <option value="copy">
                                <small>{{translations.core.view_text_copy}}</small>
                            </option>
                            <option v-if="clone_options.cloud_object_options[main_attribute.column] != null" value="custom">
                                <small>{{translations.core.view_text_custom}}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
                <div class="column is-7" v-if="workflow_action.input_data[main_attribute.column] == 'custom'">
                    <div class="field">
                        <label class="label">{{translations.actions.view_text_select_custom_value}}<sup class="has-text-danger">*</sup></label>
                        <b-select placeholder="Select an option" expanded v-model="workflow_action.input_data[`${main_attribute.column}_custom_value`]" required>
                            <option v-for="(option, index) in clone_options.cloud_object_options[main_attribute.column]" :key="index" :value="option.id">
                                <small>{{option.name_translated || option.name}}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
            </div>
            <div class="columns" v-for="detail_attribute in clone_options.detail_attributes" :key="detail_attribute.column">
                <div class="column is-5">
                    <div class="field">
                        <label class="label">{{detail_attribute.label}}<sup class="has-text-danger">*</sup></label>
                        <b-select placeholder="Select an option" expanded v-model="workflow_action.input_data[detail_attribute.column]" required>
                            <option value="copy">
                                <small>{{translations.core.view_text_copy}}</small>
                            </option>
                            <option value="serial">
                                <small>{{translations.core.view_text_serial}}</small>
                            </option>
                            <option value="custom">
                                <small>{{translations.core.view_text_custom}}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
                <div class="column is-7" v-if="workflow_action.input_data[detail_attribute.column] == 'custom'">
                    <div class="field">
                        <label class="label">{{translations.actions.view_title_enter_custom_value}}</label>
                        <b-input type="text" v-model="workflow_action.input_data[`${detail_attribute.column}_custom_value`]">
                        </b-input>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
