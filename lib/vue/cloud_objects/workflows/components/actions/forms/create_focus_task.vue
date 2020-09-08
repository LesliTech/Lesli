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
        }
    },

    data(){
        return {
            translations: {
                core: I18n.t('deutscheleibrenten.shared'),
                tasks: I18n.t('deutscheleibrenten.tasks')
            },
            workflow_action: null,
            task_options: {
                importances: [],
                task_types: [],
                users: []
            }
        }
    },

    mounted(){
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getFocusTaskOptions()
        this.getTaskUserOptions()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-create_focus_task`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-create_focus_task`, (action, callback)=>{
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

        getFocusTaskOptions(){
             this.http.get(`/focus/tasks/options.json?view_type=index`).then(result => {
                if (result.successful) {
                    for(let key in result.data){
                        this.$set(this.task_options, key, result.data[key])
                    }
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        getTaskUserOptions(){
            this.http.get(`/users.json?role=kop,callcenter,api&type=exclude`).then(result => {
                if (result.successful) {
                    this.$set(this.task_options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        addReference(reference, field){
            let field_value = this.workflow_action.input_data[field] || ''
            field_value = `${field_value} %${reference}% `

            this.workflow_action.input_data[field] = field_value
        }
    },

    computed: {
        filteredUsers(){
            return this.task_options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.workflow_action.concerning_users.list[0].name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="field">
            <label class="label">
                {{translations.core.text_title}}<sup class="has-text-danger">*</sup>
                <span class="is-pulled-right">
                    <b-tooltip :label="translations.main.tooltip_add_resource_identifier_reference" size="is-small" position="is-left" type="is-light">
                        <b-button size="is-small" @click="addReference('global_identifier', 'title')">
                            <b-icon size="is-small" icon="barcode">
                            </b-icon>
                        </b-button>
                    </b-tooltip>
                    <b-tooltip :label="translations.main.tooltip_add_current_user_reference" size="is-small" position="is-left" type="is-light">
                        <b-button size="is-small" @click="addReference('current_user', 'title')">
                            <b-icon size="is-small" icon="user-circle">
                            </b-icon>
                        </b-button>
                    </b-tooltip>
                </span>
            </label>
            <div class="control">
                <input class="input" type="text" v-model="workflow_action.input_data.title" required>
            </div>
        </div>
        <div class="field">
            <label class="label">
                {{translations.core.text_description}}
                <span class="is-pulled-right">
                    <b-tooltip :label="translations.main.tooltip_add_resource_identifier_reference" size="is-small" position="is-left" type="is-light">
                        <b-button size="is-small" @click="addReference('global_identifier', 'description')">
                            <b-icon size="is-small" icon="barcode">
                            </b-icon>
                        </b-button>
                    </b-tooltip>
                    <b-tooltip :label="translations.main.tooltip_add_current_user_reference" size="is-small" position="is-left" type="is-light">
                        <b-button size="is-small" @click="addReference('current_user', 'description')">
                            <b-icon size="is-small" icon="user-circle">
                            </b-icon>
                        </b-button>
                    </b-tooltip>
                </span>
            </label>
            <div class="control">
                <b-input type="textarea" v-model="workflow_action.input_data.description"></b-input>
            </div>
        </div>
        <div class="columns">
            <div class="column is-7">
                <label class="label">{{translations.core.text_type}}<sup class="has-text-danger">*</sup></label>
                <b-select :placeholder="translations.core.text_select_option" expanded v-model="workflow_action.input_data.task_type" required>
                    <option
                        v-for="type in task_options.task_types"
                        :value="type.value"
                        :key="type.value"
                    >
                        <small>{{ object_utils.translateEnum(translations.tasks, 'enum_task_type', type.text) }}</small>
                    </option>
                </b-select>
            </div>
            <div class="column is-5">
                <label class="label">{{translations.tasks.form_task_importance}}<sup class="has-text-danger">*</sup></label>
                <b-select :placeholder="translations.core.text_select_option" expanded v-model="workflow_action.input_data.importance" required>
                    <option
                        v-for="importance in task_options.importances"
                        :value="importance.value"
                        :key="importance.value"
                    >
                        <small>{{ object_utils.translateEnum(translations.tasks, 'enum_task_importance', importance.text) }}</small>
                    </option>
                </b-select>
            </div>
        </div>
        
        <div class="columns">
            <div class="column is-6">
                <label class="label">{{translations.main.field_days_until_deadline}}<sup class="has-text-danger">*</sup></label>
                <b-input v-model="workflow_action.input_data.days_until_deadline" type="number" min="0" step="1" required></b-input>
            </div>
            <div class="column is-6">
                <label class="label">{{translations.main.field_assign_task_to}}<sup class="has-text-danger">*</sup></label>
                <b-select :placeholder="translations.core.text_select_option" expanded v-model="workflow_action.concerning_users.type" required>
                    <option
                        v-for="concerning_user_type in options.concerning_user_types"
                        :value="concerning_user_type.value"
                        :key="concerning_user_type.value"
                    >
                        <small>
                            {{ object_utils.translateEnum(translations.main, 'enum_concerning_user_types', concerning_user_type.text) }}
                        </small>
                    </option>
                </b-select>
            </div>
        </div>
        
        <div class="field" v-if="workflow_action.concerning_users.type == 'custom'">
            <label class="label">{{translations.core.text_employee}}<sup class="has-text-danger">*</sup></label>
            <div class="control">
                <b-autocomplete
                    :placeholder="translations.core.text_select_employee"
                    v-model="workflow_action.concerning_users.list[0].name"
                    required
                    field="name"
                    @select="user => workflow_action.concerning_users.list[0].id = user.id"
                    :data="filteredUsers"
                >
                </b-autocomplete>
            </div>
        </div>
        
        <div class="columns">
            <div class="column is-4">
                <div class="field">
                    <label class="label">{{translations.main.field_send_task_notification_email}}</label>
                    <div class="control">
                        <b-checkbox v-model="workflow_action.configuration.send_email" >
                            <span v-if="workflow_action.configuration.send_email">
                                {{translations.core.text_yes}}
                            </span>
                            <span v-else>
                                {{translations.core.text_no}}
                            </span>
                        </b-checkbox>
                    </div>
                </div>
            </div>
            <div class="column is-4">
                <div class="field">
                    <label class="label">{{translations.main.field_log_task_errors}}</label>
                    <div class="control">
                        <b-checkbox v-model="workflow_action.configuration.log_errors" >
                            <span v-if="workflow_action.configuration.log_errors">
                                {{translations.core.text_yes}}
                            </span>
                            <span v-else>
                                {{translations.core.text_no}}
                            </span>
                        </b-checkbox>
                    </div>
                </div>
            </div>
        </div> 
    </section>
</template>
