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
            pagination: {
                current_page: 1,
                per_page: 5
            },
            workflow_action: null,
            email_options: {
                users: []
            },
            selected_user: '',
        }
    },

    mounted(){
        this.setSubscriptions()
        this.setTranslations()
        this.cloneWorkflowAction()
        this.getUsers()
    },

    beforeDestroy(){
        this.bus.$off(`sync:/module/workflow/action/${this.viewType}-send_core_email`)
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe(`sync:/module/workflow/action/${this.viewType}-send_core_email`, (action, callback)=>{
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
                    this.alert(this.translations.main.notification_send_core_email_address_empty, 'danger')
                }
            })
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        cloneWorkflowAction(){
            let copy = JSON.parse(JSON.stringify(this.workflowAction))
            if(Object.keys(copy.concerning_users.list[0]).length == 0){
                copy.concerning_users.list = []
            }

            copy.configuration = {
                mailer: "::HausMailer"
            }

            

            this.workflow_action = copy
        },

        getUsers(){
            this.http.get('/users.json?role=kop&type=exclude').then(result => {
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
        <div class="field">
            <label class="label">{{translations.main.field_subject}}<sup class="has-text-danger">*</sup></label>
            <div class="control">
                <input class="input" type="text" v-model="workflow_action.input_data.subject" required>
            </div>
        </div>
        <div class="field">
            <label class="label">{{translations.main.field_body}}<sup class="has-text-danger">*</sup></label>
            <b-input expanded type="textarea" v-model="workflow_action.input_data.body" required>
            </b-input>
        </div>
        <div class="field">
            <label class="label">{{translations.main.field_send_email_to}}<sup class="has-text-danger">*</sup></label>
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
        <div v-if="workflow_action.concerning_users.type == 'custom'">
            <label class="label">{{translations.main.field_select_employee_or_email_address}}</label>
            <b-field grouped >
                <b-autocomplete
                    expanded
                    ref="autocomplete"
                    :placeholder="translations.core.text_select_employee"
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
                        {{translations.main.btn_add_email_address}}
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
                    <b-table-column field="name" :label="translations.core.text_name" sortable>
                        <span v-if="props.row.name">
                            {{ props.row.name }}
                        </span>
                        <span v-else>
                            {{translations.core.text_not_applicable}}
                        </span>
                    </b-table-column>
                    <b-table-column field="email" :label="translations.core.text_email" sortable>
                        {{ props.row.email }}
                    </b-table-column>
                    <b-table-column field="actions" :label="translations.core.text_delete" sortable numeric>
                        <a class="delete" role="button" @click="removeUserFromList(props.row)"></a>
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </section>
</template>
