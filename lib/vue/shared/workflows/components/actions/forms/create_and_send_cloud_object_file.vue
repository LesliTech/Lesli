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
            },
            files_route: null,
            pagination: {
                current_page: 1,
                per_page: 5
            },
            workflow_action: null,
            email_options: {
                users: []
            },
            selected_user: '',
            file_options: {
                templates: {},
                file_types: []
            },
            link_options: {
                system_urls: []
            },
            action_unavailable: false
        }
    },

    mounted(){
        this.setFilesRoute()
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getUsers()
        this.getCloudObjectFileOptions()
        this.getGenerateAndSendDocumentOptions()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-create_and_send_cloud_object_file`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-create_and_send_cloud_object_file`, (action, callback)=>{
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
                    this.msg.error(this.translations.actions.messages_warning_send_core_email_address_empty)
                }
            })
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        cloneWorkflowAction(){
            let copy = JSON.parse(JSON.stringify(this.workflowAction))

            if(! copy.concerning_users.list){
                copy.concerning_users.list = []
            }

            copy.configuration = {
                mailer: "::DeutscheLeibrentenMailer"
            }
            this.workflow_action = copy
        },

        getUsers(){
            this.http.get('/administration/users/list.json?role=kop,callcenter,api,support&type=exclude').then(result => {
                if (result.successful) {
                    this.$set(this.email_options, 'users', result.data)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        addUserToList(user){
            if(user){
                this.workflow_action.concerning_users.list.push({
                    id: user.id,
                    email: user.email,
                    name: user.name
                })
                this.$nextTick(()=>{
                    this.selected_user = ''
                    this.$refs.autocomplete.focus()
                })
            }
        },

        addEmailToList(){
            if(this.selected_user && this.selected_user.length > 0){
                this.workflow_action.concerning_users.list.push({
                    email: this.selected_user
                })
            }
            this.$nextTick(()=>{
                this.selected_user = ''
                this.$refs.autocomplete.focus()
            })
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
        },

        addReference(reference, field){
            let field_value = this.workflow_action.input_data[field] || ''
            field_value = `${field_value} %${reference}% `

            this.$set(this.workflow_action.input_data, field, field_value)
        },

        setFilesRoute(){
            if(this.engineNamespace == 'crm'){
                this.files_route = '/house/workflows'
            }else if(this.engineNamespace == '/'){
                this.files_route = '/workflows'
            }else{
                this.files_route = `/${this.engineNamespace}/workflows`
            }
        },

        getCloudObjectFileOptions(){
            let url = `${this.files_route}/${this.workflowId}/actions/resources/options_create_cloud_object_file.json`

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
        },

        getGenerateAndSendDocumentOptions(){
            let url = `${this.files_route}/${this.workflowId}/actions/resources/options_generate_and_send_cloud_object_file.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.link_options = result.data
                }
            }).catch(error => {
                console.log(error)
            }) 
        }
    },

    computed: {
        filteredUsers(){
            let filtered_users = this.email_options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes(this.selected_user.toLowerCase())
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
        <div v-if="action_unavailable" class="has-text-centered">
            <i class="fas fa-exclamation-triangle fa-lg"></i>
            <br>
            {{translations.actions.view_text_no_templates_available}}
        </div>
        <div v-else>
            <div class="email-section">
                <div class="field">
                    <label class="label">{{translations.actions.column_subject}}
                        <sup class="has-text-danger">*</sup>
                        <span class="is-pulled-right">
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_resource_identifier_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('global_identifier', 'subject')">
                                    <b-icon size="is-small" icon="barcode">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_status_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('status', 'subject')">
                                    <b-icon size="is-small" icon="project-diagram">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_current_user_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('current_user', 'subject')">
                                    <b-icon size="is-small" icon="user-circle">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_creator_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_creator', 'subject')">
                                    <b-icon size="is-small" icon="user-tie">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_reviewer_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_reviewer', 'subject')">
                                    <b-icon size="is-small" icon="user-check">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_branch_office_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_branch_office', 'subject')">
                                    <b-icon size="is-small" icon="user-tag">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                        </span>
                    </label>
                    <div class="control">
                        <input class="input" type="text" v-model="workflow_action.input_data.subject" required>
                    </div>
                </div>
                <div class="field">

                    <label class="label">
                        {{translations.actions.column_body}}<sup class="has-text-danger">*</sup>
                        <span class="is-pulled-right">
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_resource_identifier_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('global_identifier', 'body')">
                                    <b-icon size="is-small" icon="barcode">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_status_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('status', 'body')">
                                    <b-icon size="is-small" icon="project-diagram">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_current_user_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('current_user', 'body')">
                                    <b-icon size="is-small" icon="user-circle">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_creator_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_creator', 'body')">
                                    <b-icon size="is-small" icon="user-tie">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_reviewer_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_reviewer', 'body')">
                                    <b-icon size="is-small" icon="user-check">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                            <b-tooltip :label="translations.actions.messages_info_tooltip_add_user_branch_office_reference" size="is-small" position="is-left" type="is-light">
                                <b-button size="is-small" @click="addReference('user_branch_office', 'body')">
                                    <b-icon size="is-small" icon="user-tag">
                                    </b-icon>
                                </b-button>
                            </b-tooltip>
                        </span>
                    </label>
                    <b-input expanded type="textarea" v-model="workflow_action.input_data.body" required>
                    </b-input>
                </div>
                <b-field :label="translations.actions.column_add_link_to_email">
                    <b-select expanded v-model="workflow_action.input_data.system_url">
                        <option
                            v-for="url in link_options.system_urls"
                            :key="url.name"
                            :value="url.endpoint"
                        >
                            {{object_utils.translateEnum(translations.actions, 'column_enum_add_link_to_email', url.name)}}
                        </option>
                    </b-select>
                </b-field>
                <div class="field">
                    <label class="label">{{translations.actions.column_send_email_to}}<sup class="has-text-danger">*</sup></label>
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
                <div v-if="workflow_action.concerning_users.type == 'custom'">
                    <label class="label">{{translations.actions.column_select_employee_or_email_address}}</label>
                    <b-field grouped >
                        <b-autocomplete
                            expanded
                            ref="autocomplete"
                            :placeholder="translations.actions.view_placeholder_select_employee"
                            v-model="selected_user"
                            field="name"
                            @select="addUserToList"
                            :data="filteredUsers"
                        >
                        </b-autocomplete>
                        <p class="control">
                            <b-button native-type="button" outlined @click="addEmailToList">
                                <b-icon size="is-small" icon="plus">
                                </b-icon>
                                &nbsp;
                                {{translations.actions.view_btn_add_email_address}}
                            </b-button>
                        </p>
                    </b-field>
                    <b-table
                        :data="workflow_action.concerning_users.list"
                        paginated
                        :per-page="pagination.per_page"
                        :current-page.sync="pagination.current_page"
                        :pagination-simple="false"
                        pagination-position="bottom"
                        aria-next-label="Next page"
                        aria-previous-label="Previous page"
                        aria-page-label="Page"
                        aria-current-label="Current page"
                    >
                        <template slot-scope="props">
                            <b-table-column field="name" :label="translations.core.view_text_name" sortable>
                                <span v-if="props.row.name">
                                    {{ props.row.name }}
                                </span>
                                <span v-else>
                                    {{translations.core.view_text_not_applicable}}
                                </span>
                            </b-table-column>
                            <b-table-column field="email" :label="translations.core.view_text_email" sortable>
                                {{ props.row.email }}
                            </b-table-column>
                            <b-table-column field="actions" :label="translations.core.view_btn_delete" sortable numeric>
                                <a class="delete" role="button" @click="removeUserFromList(props.row)"></a>
                            </b-table-column>
                        </template>
                    </b-table>
                </div>
            </div>
            <div class="file-section">
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
        </div>
    </section>
</template>
