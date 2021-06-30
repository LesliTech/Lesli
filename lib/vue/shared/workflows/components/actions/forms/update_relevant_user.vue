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
            required: true
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
            users: [],
            selected_user_names: {
                user_main: '',
                user_reviewer: ''
            },
            selected_users: {
                user_main: null,
                user_reviewer: null
            }
        }
    },

    mounted(){
        this.setSubscriptions()
        this.cloneWorkflowAction()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-update_relevant_user`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-update_relevant_user`, (action, callback)=>{
                if(this.workflow_action.concerning_users.type != 'custom' || this.workflow_action.concerning_users.list.length > 0){
                    this.$set(action, 'template_path', this.workflow_action.template_path)
                    this.$set(action, 'input_data', this.workflow_action.input_data)
                    this.$set(action, 'system_data', this.workflow_action.system_data)
                    this.$set(action, 'concerning_users', this.workflow_action.concerning_users)
                    this.$set(action, 'configuration', this.workflow_action.configuration)
                    if(callback){
                        callback()
                    }
                }else{
                    this.msg.error(this.translations.actions.messages_warning_update_relevant_user_address_empty)
                }
            })
        },

        cloneWorkflowAction(){
            this.workflow_action = JSON.parse(JSON.stringify(this.workflowAction))
        },

        getUsers(){
            this.http.get('/administration/users/list.json?role=kop,callcenter,api,support&type=exclude').then(result => {
                if (result.successful) {
                    this.users = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        selectUser(user, user_type){
            console.log(JSON.stringify(user))
            console.log(user_type)
            if(user){
                this.workflow_action.input_data[user_type]  = user
            }
        },

        removeUserFromList(user){
            if(user.id){
                this.workflow_action.concerning_users.list = this.workflow_action.concerning_users.list.filter((concerning_user)=>{
                    return user.id != concerning_user.id
                })
            }else{
                this.workflow_action.concerning_users.list = this.workflow_action.concerning_users.list.filter((concerning_user)=>{
                    return user.email != concerning_user.email
                })
            }
        }
    },

    computed: {
        filteredUsers(){
            let filtered_users = this.users.filter((user) => {
                return (user.name || "").toLowerCase().includes(this.selected_user_names.user_main.toLowerCase())
            })
            this.workflow_action.concerning_users.list.forEach((user)=>{
                filtered_users = filtered_users.filter((filtered_user) => filtered_user.email != user.email)
            })

            return filtered_users
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div>
            <h4 class="title is-4">
                {{translations.actions.view_title_update_user_main}}
            </h4>
            <div class="columns">
                <div class="column is-9">
                    <b-field
                        :label="translations.actions.view_title_select_concerning_user_type"
                        :message="translations.actions.view_text_select_concerning_user_type_description"
                    >
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
                    </b-field>
                </div>
                <div class="column is-3">
                    <b-field>
                        <template v-slot:label> &nbsp; </template>
                        <b-button expanded @click="clearSelectedUser('user_main')">
                            {{translations.core.view_btn_clear}}
                        </b-button>
                    </b-field>
                </div>
            </div>
            <div v-if="workflow_action.concerning_users.type == 'custom'">
                <label class="label">{{translations.actions.view_placeholder_select_employee}}</label>
                <b-field grouped >
                    <b-autocomplete
                        expanded
                        ref="autocomplete"
                        :placeholder="translations.actions.view_placeholder_select_employee"
                        v-model="selected_user_names.user_main"
                        field="name"
                        @select="(option, event)=>{selectUser(option, 'user_main')}"
                        :data="filteredUsers"
                    >
                    </b-autocomplete>
                </b-field>
            </div>
        </div>


        <div>
        </div>

    </section>
</template>
