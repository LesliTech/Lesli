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
                user_reviewer: '',
                user_branch_office: ''
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
            if(! this.workflow_action.input_data.relevant_user_flags){
                this.$set(this.workflow_action.input_data, 'relevant_user_flags', {
                    user_main: null,
                    user_reviewer: null,
                    user_branch_office: null
                })
            }

            if(! this.workflow_action.input_data.relevant_user_values){
                this.$set(this.workflow_action.input_data, 'relevant_user_values', {
                    user_main: {id: null, name: ''},
                    user_reviewer: {id: null, name: ''},
                    user_branch_office: {id: null, name: ''}
                })
            }
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
            if(user){
                this.$set(this.workflow_action.input_data.relevant_user_values[user_type], 'name', user.name)
                this.$set(this.workflow_action.input_data.relevant_user_values[user_type], 'id', user.id)
            }
        },

        clearSelectedUser(user_type){
            this.$set(this.workflow_action.input_data.relevant_user_flags, user_type, null)
            this.$set(this.workflow_action.input_data.relevant_user_values[user_type], 'name', '')
            this.$set(this.workflow_action.input_data.relevant_user_values[user_type], 'id', null)
        },

        filteredUsers(user_type){
            let filtered_users = this.users.filter((user) => {
                return (user.name || "").toLowerCase().includes(
                    this.workflow_action.input_data.relevant_user_values[user_type].name.toLowerCase()
                )
            })

            return filtered_users
        }
    },

    computed: {
        filteredMainUsers(){
            return this.filteredUsers('user_main')
        },

        filteredReviewerUsers(){
            return this.filteredUsers('user_reviewer')
        },

        filteredBranchOfficeUsers(){
            return this.filteredUsers('user_branch_office')
        }
    }
}
</script>
<template>
    <section v-if="workflow_action">
        <div>
            <h4 class="title is-5">
                {{translations.actions.view_title_update_user_main}}
            </h4>
            <div class="columns">
                <div class="column is-5">
                    <b-field
                        :label="translations.actions.view_title_select_concerning_user_type"
                        :message="translations.actions.view_text_select_concerning_user_type_description"
                    >
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            v-model="workflow_action.input_data.relevant_user_flags.user_main"
                        >
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
                <div class="column is-5">
                    <div v-if="workflow_action.input_data.relevant_user_flags.user_main == 'custom'">
                        <label class="label">
                            {{translations.actions.view_placeholder_select_employee}}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <b-field grouped >
                            <b-autocomplete
                                expanded
                                required
                                :placeholder="translations.actions.view_placeholder_select_employee"
                                v-model="workflow_action.input_data.relevant_user_values.user_main.name"
                                field="name"
                                @select="(option, event)=>{selectUser(option, 'user_main')}"
                                :data="filteredMainUsers"
                            >
                            </b-autocomplete>
                        </b-field>
                    </div>
                </div>
                <div class="column is-2">
                    <b-field>
                        <template v-slot:label> &nbsp; </template>
                        <b-button expanded @click="clearSelectedUser('user_main')">
                            <b-icon icon="eraser" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_clear}}</span>
                        </b-button>
                    </b-field>
                </div>
            </div>
        </div>

        <hr>

        <div>
            <h4 class="title is-5">
                {{translations.actions.view_title_update_user_reviewer}}
            </h4>
            <div class="columns">
                <div class="column is-5">
                    <b-field
                        :label="translations.actions.view_title_select_concerning_user_type"
                        :message="translations.actions.view_text_select_concerning_user_type_description_with_nonexistant_field_warning"
                    >
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            v-model="workflow_action.input_data.relevant_user_flags.user_reviewer"
                        >
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
                <div class="column is-5">
                    <div v-if="workflow_action.input_data.relevant_user_flags.user_reviewer == 'custom'">
                        <label class="label">
                            {{translations.actions.view_placeholder_select_employee}}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <b-field grouped >
                            <b-autocomplete
                                expanded
                                required
                                :placeholder="translations.actions.view_placeholder_select_employee"
                                v-model="workflow_action.input_data.relevant_user_values.user_reviewer.name"
                                field="name"
                                @select="(option, event)=>{selectUser(option, 'user_reviewer')}"
                                :data="filteredReviewerUsers"
                            >
                            </b-autocomplete>
                        </b-field>
                    </div>
                </div>
                <div class="column is-2">
                    <b-field>
                        <template v-slot:label> &nbsp; </template>
                        <b-button expanded @click="clearSelectedUser('user_reviewer')">
                            <b-icon icon="eraser" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_clear}}</span>
                        </b-button>
                    </b-field>
                </div>
            </div>
        </div>

        <hr>

        <div>
            <h4 class="title is-5">
                {{translations.actions.view_title_update_user_branch_office}}
            </h4>
            <div class="columns">
                <div class="column is-5">
                    <b-field
                        :label="translations.actions.view_title_select_concerning_user_type"
                        :message="translations.actions.view_text_select_concerning_user_type_description_with_nonexistant_field_warning"
                    >
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            v-model="workflow_action.input_data.relevant_user_flags.user_branch_office"
                        >
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
                <div class="column is-5">
                    <div v-if="workflow_action.input_data.relevant_user_flags.user_branch_office == 'custom'">
                        <label class="label">
                            {{translations.actions.view_placeholder_select_employee}}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <b-field grouped >
                            <b-autocomplete
                                expanded
                                required
                                :placeholder="translations.actions.view_placeholder_select_employee"
                                v-model="workflow_action.input_data.relevant_user_values.user_branch_office.name"
                                field="name"
                                @select="(option, event)=>{selectUser(option, 'user_branch_office')}"
                                :data="filteredBranchOfficeUsers"
                            >
                            </b-autocomplete>
                        </b-field>
                    </div>
                </div>
                <div class="column is-2">
                    <b-field>
                        <template v-slot:label> &nbsp; </template>
                        <b-button expanded @click="clearSelectedUser('user_branch_office')">
                            <b-icon icon="eraser" size="is-small"></b-icon>
                            <span> {{translations.core.view_btn_clear}} </span>
                        </b-button>
                    </b-field>
                </div>
            </div>
        </div>

    </section>
</template>
