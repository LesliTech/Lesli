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
                core: I18n.t('core.shared')
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
            this.http.get(`/crm/options/tasks/users.json`).then(result => {
                if (result.successful) {
                    this.$set(this.task_options, 'users', result.data)
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
        <div class="field">
            <label class="label">Title<sup class="has-text-danger">*</sup></label>
            <div class="control">
                <input class="input" type="text" v-model="workflow_action.input_data.title" required>
            </div>
        </div>
        <div class="field">
            <label class="label">Description</label>
            <div class="control">
                <b-input type="textarea" v-model="workflow_action.input_data.description"></b-input>
            </div>
        </div>
        <div class="columns">
            <div class="column is-7">
                <label class="label">Type<sup class="has-text-danger">*</sup></label>
                <b-select placeholder="Select an option" expanded v-model="workflow_action.input_data.task_type" required>
                    <option
                        v-for="type in task_options.task_types"
                        :value="type.value"
                        :key="type.value"
                    >
                        <small>{{ type.text }}</small>
                    </option>
                </b-select>
            </div>
            <div class="column is-5">
                <label class="label">Importance<sup class="has-text-danger">*</sup></label>
                <b-select placeholder="Select an option" expanded v-model="workflow_action.input_data.importance" required>
                    <option
                        v-for="importance in task_options.importances"
                        :value="importance.value"
                        :key="importance.value"
                    >
                        <small>{{ importance.text }}</small>
                    </option>
                </b-select>
            </div>
        </div>
        
        <div class="columns">
            <div class="column is-6">
                <label class="label">Days until deadline<sup class="has-text-danger">*</sup></label>
                <b-input v-model="workflow_action.input_data.days_until_deadline" type="number" min="0" step="1" required></b-input>
            </div>
            <div class="column is-6">
                <label class="label">Assign this task to<sup class="has-text-danger">*</sup></label>
                <b-select placeholder="Select an option" expanded v-model="workflow_action.concerning_users.type" required>
                    <option
                        v-for="concerning_user_type in options.concerning_user_types"
                        :value="concerning_user_type.value"
                        :key="concerning_user_type.value"
                    >
                        <small>{{ concerning_user_type.text }}</small>
                    </option>
                </b-select>
            </div>
        </div>
        <div class="field" v-if="workflow_action.concerning_users.type == 'custom'">
            <label class="label">Employee<sup class="has-text-danger">*</sup></label>
            <div class="control">
                <b-select placeholder="Select an employee" expanded v-model="workflow_action.concerning_users.list[0].id" required>
                    <option
                        v-for="user in task_options.users"
                        :value="user.id"
                        :key="user.id"
                    >
                        <small v-if="user.name && user.name.trim().length > 0">{{ user.name }}</small>
                        <small v-else>{{ user.email }}</small>
                    </option>
                </b-select>
            </div>
        </div>
        
        <div class="columns">
            <div class="column is-4">
                <div class="field">
                    <label class="label">Send notification email</label>
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
                    <label class="label">Log any error that occurs</label>
                    <div class="control">
                        <b-checkbox v-model="workflow_action.configuration.log_activity" >
                            <span v-if="workflow_action.configuration.log_activity">
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
