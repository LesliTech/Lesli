<script>
import componentFormCreateFocusTask from './forms/create_focus_task.vue'
import componentFormSendCoreEmail from './forms/send_core_email.vue'
import componentFormCreateBellNotification from './forms/create_bell_notification.vue'

export default {
    props: {
        workflowId: {
            required: true
        },

        cloudEngine: {
            required: true
        },
        translationsPath: {
            required: true,
            type: String
        },
        statusesTranslationsPath: {
            required: true,
            type: String
        },
        viewType: {
            type: String,
            default: 'new'
        }
    },

    components: {
        'component-form-create-focus-task': componentFormCreateFocusTask,
        'component-form-send-core-email': componentFormSendCoreEmail,
        'component-form-create-bell-notification': componentFormCreateBellNotification
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared')
            },
            main_route: '',
            action: {
                initial_status_id: null,
                final_status_id: null,
                name: '',
                action_type: null,
                execute_immediately: false,
                template_path: null,
                input_data: {},
                system_data: {},
                concerning_users: {
                    list: [
                        {}
                    ]
                },
                configuration: {}

            },
            action_id: null,
            options: {
                statuses: []
            },
            transition_statuses: [],
            loading: false
        }
    },

    mounted(){
        this.setMainRoute()
        this.setTranslations()
        this.setSubscriptions()
        this.getActionOptions()
    },

    methods: {
        setMainRoute(){
            this.main_route = `/${this.cloudEngine}/workflows/${this.workflowId}/actions`
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
            this.$set(this.translations, 'statuses', I18n.t(this.statusesTranslationsPath))
        },

        setSubscriptions(){
            if(this.viewType == 'edit'){
                this.bus.subscribe('show:/module/workflow/action/edit', (action)=>{
                    this.action_id = action.id
                    this.getWorkflowAction()
                })
            }
        },

        getActionOptions(){
            let url = `/${this.cloudEngine}/workflows/${this.workflowId}/actions/options`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                    this.transition_statuses = Object.values(result.data.statuses)
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getWorkflowAction(){
            this.loading = true
            this.resetAction()
            let url = `${this.main_route}/${this.action_id}.json`

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.action = result.data
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        resetAction(){
            this.action = {
                initial_status_id: null
            }
        },

        submitAction(event){
            if(event){
                event.preventDefault()
            }

            this.bus.publish(`sync:/module/workflow/action/${this.viewType}-${this.action.action_type}`, this.action, ()=>{
                if(this.action_id){
                    this.putAction()
                }else{
                    this.postAction()
                }
            })
        },

        postAction(){
            let url = `${this.main_route}`

            let data = {
                workflow_action: this.action
            }

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    this.notification.alert(this.translations.main.notification_action_created,'success')
                    this.bus.publish('post:/module/workflow/action', result.data)
                    this.bus.publish('show:/module/workflow/action/edit', result.data)
                    this.resetAction()
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putAction(){
            let url = `${this.main_route}/${this.action_id}`

            let data = {
                workflow_action: this.action
            }

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.notification.alert(this.translations.main.notification_action_updated,'success')
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        deleteAction(){
            let url = `${this.main_route}/${this.action_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.notification.alert(this.translations.main.notification_action_deleted,'success')
                    this.bus.publish('destroy:/module/workflow/action', this.action)
                    this.action_id = null
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        resetAction(){
            this.action = {
                initial_status_id: null,
                final_status_id: null,
                name: '',
                action_type: null,
                execute_immediately: false,
                template_path: null,
                input_data: {},
                system_data: {},
                concerning_users: {
                    list: [
                        {}
                    ]
                },
                configuration: {}
            }
        }
    },

    beforeDestroy(){
        this.bus.$off('show:/module/workflow/action/edit')
    },

    watch: {
        'action.initial_status_id'(){
            let transition_statuses = []
            if(this.action.initial_status_id){
                let initial_status = Object.values(this.options.statuses).find( status => status.id == this.action.initial_status_id)
                if(initial_status){
                    initial_status.next_statuses.forEach((status_number) => {
                        transition_statuses.push(this.options.statuses[status_number])
                    })
                }
            }else{
                transition_statuses = Object.values(this.options.statuses)
            }
            this.transition_statuses = transition_statuses
        }
    },

    computed: {
        initialStatuses(){
            if(this.options.statuses){
                let initial_statuses = Object.values(this.options.statuses)
                initial_statuses.unshift({
                    id: null,
                    name: this.translations.core.text_none,
                    number: null
                })
                return initial_statuses
            }else{
                return []
            }
        }
    }
}
</script>
<template>
    <div v-if="translations.main">
        <article class="message is-warning" v-if="viewType == 'new' && options.has_global_association && cloudEngine == 'focus'">
            <div class="message-header">
                <p>{{translations.core.warning_new_focus_global_action_title}}</p>
            </div>
            <div class="message-body">
                {{translations.core.warning_new_focus_global_action_body}}
            </div>
        </article>
        <component-data-loading v-if="loading" />
        <form v-if="!loading && (viewType == 'new' || action_id)" @submit="submitAction">
            <div class="field">
                <label class="label">{{translations.core.text_name}}<sup class="has-text-danger">*</sup></label>
                <div class="control">
                    <input class="input" type="text" v-model="action.name" required>
                </div>
            </div>
            <div class="columns">
                <div class="column is-6">
                    <div class="field">
                        <label class="label">{{translations.main.field_initial_status}}</label>
                        <b-select expanded v-model="action.initial_status_id">
                            <option
                                v-for="status in initialStatuses"
                                :value="status.id"
                                :key="status.id"
                            >
                                <small>{{ object_utils.translateEnum(translations.statuses, 'status', status.name) }}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
                <div class="column is-6">
                    <div class="field">
                        <label class="label">{{translations.main.field_final_status}}<sup class="has-text-danger">*</sup></label>
                        <b-select :placeholder="translations.core.text_select_option" expanded v-model="action.final_status_id" required>
                            <option
                                v-for="status in transition_statuses"
                                :value="status.id"
                                :key="status.id"
                            >
                                <small>{{ object_utils.translateEnum(translations.statuses, 'status', status.name) }}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
            </div>
            <div class="columns">
                <div class="column is-8">
                    <div class="field">
                    <label class="label">{{translations.main.field_action_type}}<sup class="has-text-danger">*</sup></label>
                        <b-select :placeholder="translations.core.text_select_option" expanded v-model="action.action_type" required :disabled="viewType == 'edit'">
                            <option
                                v-for="type in options.action_types"
                                :value="type.value"
                                :key="type.value"
                            >
                                <small>{{ object_utils.translateEnum(translations.main, 'enum_action_type', type.text) }}</small>
                            </option>
                        </b-select>
                    </div>
                </div>
                <div class="column is-4">
                    <div class="field">
                        <label class="label">{{translations.main.field_execute_immediately}}</label>
                        <div class="control">
                            <b-checkbox v-model="action.execute_immediately" >
                                <span v-if="action.execute_immediately">
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
            <hr>
            <component-form-create-bell-notification
                v-if="action.action_type == 'create_bell_notification'"
                :options="options"
                :workflow-id="workflowId"
                :translations-path="translationsPath"
                :workflow-action="action"
                :view-type="viewType"
            ></component-form-create-bell-notification>
            <component-form-create-focus-task
                v-if="action.action_type == 'create_focus_task'"
                :options="options"
                :workflow-id="workflowId"
                :translations-path="translationsPath"
                :workflow-action="action"
                :view-type="viewType"
            ></component-form-create-focus-task>
            <component-form-send-core-email
                v-if="action.action_type == 'send_core_email'"
                :options="options"
                :workflow-id="workflowId"
                :translations-path="translationsPath"
                :workflow-action="action"
                :view-type="viewType"
            ></component-form-send-core-email>
            <br>
            <div class="buttons">
                <b-button type="is-primary" expanded native-type="submit">
                    <i class="fas fa-save"></i>
                    {{translations.core.btn_save}}
                </b-button>
            </div>
            <div v-if="viewType == 'edit'">
                <hr>
                <div class="buttons">
                    <b-button type="is-danger" outlined native-type="button" @click="deleteAction">
                        <i class="fas fa-trash-alt"></i>
                        {{translations.core.text_delete}}
                    </b-button>
                </div>
            </div>
        </form>
    </div>
</template>
