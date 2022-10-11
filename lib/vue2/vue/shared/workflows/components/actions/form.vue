<script>
import componentFormCreateFocusTask from './forms/create_focus_task.vue'
import componentFormSendCoreEmail from './forms/send_core_email.vue'
import componentFormCreateBellNotification from './forms/create_bell_notification.vue'
import componentFormCloudObjectClone from './forms/cloud_object_clone.vue'
import componentFormCreateAndSendCloudObjectFile from './forms/create_and_send_cloud_object_file.vue'
import componentFormCreateCloudObjectFile from './forms/create_cloud_object_file.vue'
import componentFormSendTalkChatroomMessage from './forms/send_talk_chatroom_message.vue'
import componentFormUpdateRelevantUser from './forms/update_relevant_user.vue'

export default {
    props: {
        workflowId: {
            required: true
        },

        engineNamespace: {
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
        },
        customActionForms: {
            type: Object,
            default: ()=>{
                return {}
            }
        }
    },

    components: {
        'component-form-create-and-send-cloud-object-file': componentFormCreateAndSendCloudObjectFile,
        'component-form-create-focus-task': componentFormCreateFocusTask,
        'component-form-send-core-email': componentFormSendCoreEmail,
        'component-form-create-bell-notification': componentFormCreateBellNotification,
        'component-form-create-cloud-object-file': componentFormCreateCloudObjectFile,
        'component-form-cloud-object-clone': componentFormCloudObjectClone,
        'component-form-send-talk-chatroom-message': componentFormSendTalkChatroomMessage,
        'component-form-update-relevant-user': componentFormUpdateRelevantUser
    },

    data(){
        return {
            translations: {
                core: I18n.t('core.shared'),
                actions: I18n.t('core.workflow/actions')
            },
            main_route: '',
            action: {
                active: true,
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
            loading: false,
            submitting: false
        }
    },

    mounted(){
        this.setComponents()
        this.setMainRoute()
        this.setTranslations()
        this.setSubscriptions()
        this.getActionOptions()
    },

    methods: {
        setComponents(){
            // We configure the components based on the 'renderComponents' prop

            for(let key in this.customActionForms){
                this.$options.components[key] = this.customActionForms[key]
            }
        },

        setMainRoute(){
            if(this.engineNamespace == '/'){
                this.main_route = `/workflows/${this.workflowId}/actions`
            }else{
                this.main_route = `/${this.engineNamespace}/workflows/${this.workflowId}/actions`
            }
            
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
            let url = `${this.main_route}/options.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                    this.transition_statuses = Object.values(result.data.statuses)
                }else{
                    this.msg.error(result.error.message)
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
                    this.msg.error(result.error.message)
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
            let data = {
                workflow_action: this.action
            }
            this.submitting = true

            this.http.post(`${this.main_route}.json`, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.actions.messages_success_action_created)
                    this.bus.publish('post:/module/workflow/action', result.data)
                    this.bus.publish('show:/module/workflow/action/edit', result.data)
                    this.resetAction()
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        putAction(){
            let url = `${this.main_route}/${this.action_id}.json`

            let data = {
                workflow_action: this.action
            }
            this.submitting = true

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.actions.messages_success_action_updated)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        deleteAction(){
            let url = `${this.main_route}/${this.action_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.actions.messages_info_action_destroyed)
                    this.bus.publish('destroy:/module/workflow/action', this.action)
                    this.action_id = null
                }else{
                    this.msg.error(result.error.message)
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
                let initial_status = this.options.statuses[this.action.initial_status_id]
                if(initial_status){
                    initial_status.next_statuses.forEach((status_id) => {
                        transition_statuses.push(this.options.statuses[status_id])
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
                    name: this.translations.core.view_text_none,
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
        <article class="message is-warning" v-if="viewType == 'new' && options.has_global_association && engineNamespace == 'focus'">
            <div class="message-header">
                <p>{{translations.actions.messages_warning_new_focus_global_action_title}}</p>
            </div>
            <div class="message-body">
                {{translations.actions.messages_warning_new_focus_global_action_body}}
            </div>
        </article>
        <component-data-loading v-if="loading" />
        <form v-if="!loading && (viewType == 'new' || action_id)" @submit="submitAction">
            <fieldset :disabled="submitting">
                <div class="columns is-multiline">
                    <div class="column is-12 has-text-right">
                        <b-button v-if="viewType == 'edit'" type="is-danger" outlined native-type="button" @click="deleteAction">
                            <i class="fas fa-trash-alt"></i>
                            {{translations.core.view_btn_delete}}
                        </b-button>
                    </div>
                    <div class="column is-8">
                        <div class="field">
                            <label class="label">{{translations.actions.column_name}}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <input class="input" type="text" v-model="action.name" required>
                            </div>
                        </div>
                    </div>
                    <div class="column is-2">
                        <div class="field">
                            <label class="label">{{translations.actions.column_active}}</label>
                            <b-select expanded v-model="action.active">
                                <option :value="true">{{translations.core.view_text_yes}}</option>
                                <option :value="false">{{translations.core.view_text_no}}</option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-2">
                        <div class="field">
                            <label class="label">{{translations.actions.column_execute_immediately}}</label>
                            <div class="control">
                                <b-checkbox v-model="action.execute_immediately" >
                                    <span v-if="action.execute_immediately">
                                        {{translations.core.view_text_yes}}
                                    </span>
                                    <span v-else>
                                        {{translations.core.view_text_no}}
                                    </span>
                                </b-checkbox>
                            </div>
                        </div>
                    </div>
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{translations.actions.column_initial_status_id}}</label>
                            <b-select expanded v-model="action.initial_status_id">
                                <option
                                    v-for="status in initialStatuses"
                                    :value="status.id"
                                    :key="status.id"
                                >
                                    <small>{{
                                        object_utils.translateEnum(translations.core, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'status', status.name)
                                    }}</small>
                                </option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{translations.actions.column_final_status_id}}<sup class="has-text-danger">*</sup></label>
                            <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="action.final_status_id" required>
                                <option
                                    v-for="status in transition_statuses"
                                    :value="status.id"
                                    :key="status.id"
                                >
                                    <small>{{
                                        object_utils.translateEnum(translations.core, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'status', status.name)
                                    }}</small>
                                </option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-4">
                        <b-field :message="translations.actions.view_text_column_action_type_description">
                            <template v-slot:label>
                                {{translations.actions.column_action_type}}<sup class="has-text-danger">*</sup>
                            </template>
                            <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="action.action_type" required :disabled="viewType == 'edit'">
                                <option
                                    v-for="type in options.action_types"
                                    :value="type.value"
                                    :key="type.value"
                                >   
                                    <small>{{
                                        object_utils.translateEnum(translations.actions, 'column_enum_action_type', type.text, null) ||
                                        object_utils.translateEnum(translations.main, 'column_enum_action_type', type.text)
                                    }}</small>
                                </option>
                            </b-select>
                        </b-field>
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
                <component-form-create-cloud-object-file
                    v-if="action.action_type == 'create_cloud_object_file'"
                    :options="options"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :workflow-action="action"
                    :view-type="viewType"
                    :engine-namespace="engineNamespace"
                ></component-form-create-cloud-object-file>
                <component-form-create-and-send-cloud-object-file
                    v-if="action.action_type == 'create_and_send_cloud_object_file'"
                    :options="options"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :workflow-action="action"
                    :view-type="viewType"
                    :engine-namespace="engineNamespace"
                ></component-form-create-and-send-cloud-object-file>
                <component-form-cloud-object-clone
                    v-if="action.action_type == 'cloud_object_clone'"
                    :options="options"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :workflow-action="action"
                    :view-type="viewType"
                    :engine-namespace="engineNamespace"
                ></component-form-cloud-object-clone>
                <component-form-send-talk-chatroom-message
                    v-if="action.action_type == 'send_talk_chatroom_message'"
                    :options="options"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :workflow-action="action"
                    :view-type="viewType"
                ></component-form-send-talk-chatroom-message>
                <component-form-update-relevant-user
                    v-if="action.action_type == 'update_relevant_user'"
                    :options="options"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :workflow-action="action"
                    :view-type="viewType"
                ></component-form-update-relevant-user>

                <div v-for="(action_form, key) in customActionForms" :key="key">
                    <component
                        v-if="action.action_type == key"
                        :is="key" 
                        :options="options"
                        :workflow-id="workflowId"
                        :translations-path="translationsPath"
                        :workflow-action="action"
                        :view-type="viewType"
                    >
                    </component>
                </div>
                <br>
                <div class="buttons">
                    <b-button type="is-primary" expanded native-type="submit">
                        <span v-if="submitting">
                            <b-icon icon="circle-notch"  custom-class="fa-spin" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_save}}</span>
                        </span>
                        <span v-else>
                            <b-icon icon="save" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_save}}</span>
                        </span>
                    </b-button>
                </div>
            </fieldset>
        </form>
    </div>
</template>
