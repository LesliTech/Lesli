<script>
export default {
    props: {
        workflowId: {
            required: true
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
                core: I18n.t('core.shared'),
                actions: I18n.t('core.workflow/actions'),
            },
            workflow_action: null,
            message_options: {
                users: []
            }
        }
    },

    mounted(){
        this.setSubscriptions()
        this.cloneWorkflowAction()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-send_talk_chatroom_message`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-send_talk_chatroom_message`, (action, callback) => {
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

        getUsers(){
            this.http.get('/administration/users/list.json').then(result => {
                if (result.successful) {
                    this.$set(this.message_options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    },

    computed: {
        filteredUsers(){
            return this.message_options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.workflow_action.concerning_users.list[0].name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div class="field">
            <label class="label">{{ translations.actions.view_text_sender_user }}<sup class="has-text-danger">*</sup></label>
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
        <div class="field" v-if="workflow_action.concerning_users.type == 'custom'">
            <label class="label">{{ translations.actions.view_title_employee }}<sup class="has-text-danger">*</sup></label>
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
        <div class="field">
            <label class="label">{{ translations.actions.view_text_message_content }}</label>
            <div class="control">
                <b-input type="textarea" v-model="workflow_action.input_data.message_text">
                </b-input>
            </div>
        </div>
    </section>
</template>
