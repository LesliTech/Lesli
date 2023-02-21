/*
Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
*/

// · This store is needed to make http requests, manage the reactivity
// · of a workflow.

import { defineStore } from "pinia"

import { useWorkflow } from "LesliVue/stores/shared/workflow"
import { useRouter } from "vue-router"

export const useActions = defineStore("core.shared.workflow.actions", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            actions: [],
            loading: false,
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
                    ],
                    type: ""
                },
                configuration: {}
            },
            concerning_users: {
                type: null
            },
            options: {
                statuses: [],
                action_types: [],
                concerning_user_types: [],
                users: [],
                task_importances: [],
                task_types: []
            },
            file_options: {
                templates: {},
                file_types: []
            },
            clone_options: {},
            action_unavailable: false
        }
    },
    actions: {
        /**
        * @description This action is used to fetch the list of actions for a workflow
        */
        fetchActions() {
            this.loading = true

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.get(url).then(result => {
                this.actions = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to reset the store
         */
        reset() {
            this.action = {
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
                    ],
                    type: ""
                },
                configuration: {},
                concerning_user_types: ""
            }
        },
        /**
         * @description This action is used to get the information from a action
         * @param {Integer} action_id id of the action to be fetched
         */
        fetchAction (action_id){
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions/:actionId`, { workflowId: this.storeWorkflow.workflow.id, actionId: action_id })

            this.http.get(url).then(result => {
                this.action = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post an action for a workflow
         */
        postAction (){
                
            let data = {
                workflow_action: this.action
            }
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.post(url, data).then(result => {
                this.action = {}
                this.actions.push(result)
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to update an action for a workflow
         */
        updateAction (){
        
            let data = {
                workflow_action: this.action
            }

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions/:actionId`, { workflowId: this.storeWorkflow.workflow.id, actionId: this.action.id })

            this.http.put(url, data).then(result => {
                this.action = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },

         /**
         * @description This action is used to translate the options for an enum
         * @param {Object, String, String}
         */
         translateEnum( translations, enum_prefix, value){
            const new_value = translations[`${enum_prefix}_${value}`]
            if(new_value){
                return new_value
            }

            return value
        },
        /**
         * @description This action is used to get options for check form
         */
        getOptions(){
            this.options = {
                statuses: [],
                action_types: [],
                concerning_user_types: []
            }
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions/options`, { workflowId: this.storeWorkflow.workflow.id })

            this.loading = true

            this.http.get(url).then(result => {

                Object.values(result["statuses"]).forEach((status)=>{
                    this.options["statuses"].push({
                        label: status.name,
                        value: status.id
                    })
                })

                result["action_types"].forEach((type)=>{
                    this.options["action_types"].push({
                        label: this.translateEnum(I18n.t('core.workflow/actions'), 'column_enum_action_type', type.text),
                        value: type.value
                    })
                })

                result["concerning_user_types"].forEach((type)=>{
                    this.options["concerning_user_types"].push({
                        label: this.translateEnum(I18n.t('core.workflow/actions'), 'column_enum_action_type', type.text),
                        value: type.value
                    })
                })

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to get options for users to assign
         */
        getUsers(){
            this.http.get(this.url.admin("users/list")).then(result => {
                this.options["users"] = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }) 
        },
        /**
         * @description This action is used to get options for the task form 
         */
        getTasksOptions (){
            this.loading = true

            this.options.task_importances = []
            this.options.task_types = []

            this.http.get(this.url.focus("tasks/options")).then(result => {

                result["task_types"].forEach((type)=>{
                    this.options["task_types"].push({
                        label: type.text,
                        value: type.value
                    })
                })

                result["importances"].forEach((importance)=>{
                    this.options["task_importances"].push({
                        label: importance.text,
                        value: importance.value
                    })
                })

                this.loading = false 
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }) 

        },
        /**
         * @description This action is used to get options for creating a file
         */
        getCloudObjectFileOptions(){
            this.loading = true

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions/resources/options_create_cloud_object_file`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.get(url).then(result => {
                if(result && result.templates.length > 0){
                    this.file_options.templates = result.templates
                    this.file_options.file_types = result.file_types
                }else{
                    this.action_unavailable = true
                }
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }) 
        },
        /**
         * @description This action is used to get options for the clone object form 
         */
        getCloneOptions(){
            this.loading = true
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/actions/resources/options_cloud_object_clone`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.get(url).then(result => {
                if(result){
                    for(let key in result){
                        this.clone_options[key] = result[key]
                    }
                }else{
                    this.action_unavailable = true
                }
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }) 
        },
        /**
         * @description This action is used to add a reference to use on backend action
         * @param {String, String}
         */
        addReference(reference, field){
            let field_value = this.action.input_data[field] || ''
            this.action.input_data[field] = `${field_value} %${reference}% `
        }

    }
})
