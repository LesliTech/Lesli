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
                bell: I18n.t('deutscheleibrenten.notifications')
            },
            workflow_action: null,
            notification_options: {
                categories: [],
                users: [],
                senders: []
            }
        }
    },

    mounted(){
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getBellNotificationOptions()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-create_bell_notification`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-create_bell_notification`, (action, callback)=>{
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

        getBellNotificationOptions(){
             this.http.get('/bell/notifications/options').then(result => {
                if (result.successful) {
                    for(let key in result.data){
                        this.$set(this.notification_options, key, result.data[key])
                    }
                }
            }).catch(error => {
                console.log(error)
            }) 
        },

        getUsers(){
            this.http.get('/users.json?role=kop,callcenter,api&type=exclude').then(result => {
                if (result.successful) {
                    this.$set(this.notification_options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    },

    computed: {
        filteredUsers(){
            return this.notification_options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.workflow_action.concerning_users.list[0].name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="field">
            <label class="label">{{translations.main.field_subject}}<sup class="has-text-danger">*</sup></label>
            <div class="control">
                <input class="input" type="text" v-model="workflow_action.input_data.subject" required>
            </div>
        </div>
        <div class="columns">
            <div class="column is-5">
                <div class="field">
                    <label class="label">{{translations.core.text_category}}<sup class="has-text-danger">*</sup></label>
                    <b-select :placeholder="translations.core.text_select_option" expanded v-model="workflow_action.input_data.category" required>
                        <option
                            v-for="category in notification_options.categories"
                            :value="category.value"
                            :key="category.value"
                        >
                            <small>{{object_utils.translateEnum(translations.bell, 'enum_category', category.text)}}</small>
                        </option>
                    </b-select>
                </div> 
            </div>
            <div class="column is-7">
                <label class="label">{{translations.main.field_send_notification_to}}<sup class="has-text-danger">*</sup></label>
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
        <div class="field">
            <label class="label">{{translations.main.field_body}}</label>
            <div class="control">
                <b-input type="textarea" v-model="workflow_action.input_data.body">
                </b-input>
            </div>
        </div>
    </section>
</template>
