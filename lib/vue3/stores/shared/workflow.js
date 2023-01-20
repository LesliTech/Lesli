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

export const useWorkflow = defineStore("core.shared.workflow", {
    state: () => {
        return {
            transitionOptions: [],
            workflows: [],
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            workflow: {},
            new_status_name: ''
        }
    },
    actions: {

        /**
        * @param {*} url is the url of the api to be called
        * @description This action is used to fetch the list of transition options
        */
        fetchWorkflows(url) {
            this.loading = true

            if (!url) url = this.url[this.cloudModule](this.cloudObject)

            this.http.get(url).then(result => {
                this.workflows = result.workflows
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @param {string} stringToFind String to search for
         * @description This action is used to search for a string in the workflows
         */
        searchWorkflows(stringToFind) {
            const workflowsUrl = this.url[this.cloudModule](this.cloudObject).search(stringToFind)
            this.fetchWorkflows(workflowsUrl)
        },


        /**
        * @description This action is used to fetch the list of transition options
        */
        fetchTransitionOptions(url) {
            this.loading = true

            // · If the cloud object has / split the url
            let cloudObject = this.cloudObject.split("/").pop()
            let cloudObjectScope = null

            if (this.cloudObject.split("/").length >= 2) {
                cloudObjectScope = this.cloudObject.split("/")[0]
            }

            // · Singularize the cloud object
            cloudObject = cloudObject.endsWith("s") ? cloudObject.slice(0, -1) : cloudObject

            let path = "workflows/resources/transition-options/:cloudObject/:cloudObjectId"

            if (cloudObjectScope) {
                path = cloudObjectScope + "/" + path
            }

            if (!url) url = this.url[this.cloudModule](path, {
                cloudObject: cloudObject,
                cloudObjectId: this.cloudObjectId,
            })

            this.http.get(url).then(result => {
                if (result === "") return this.transitionOptions = []
                this.transitionOptions = result
            }).catch(error => {
                console.log(error)
                if (error?.message === "Not found") return this.transitionOptions = []
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_transition_options)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @param {*} payload
         * @description This action is used to update the cloud object status
         */
        updateStatus(payload) {
            this.loading = true

            const url = this.url[this.cloudModule](`${this.cloudObject}/:cloudObjectId`, { cloudObjectId: this.cloudObjectId })

            this.http.put(url, payload).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_status_changed)
                this.fetchTransitionOptions()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_updating_status)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to reset the store
         */
        reset() {
            this.transitionOptions = []
            this.workflows = []
            this.loading = false
            this.cloudModule = null
            this.cloudObject = null
            this.cloudObjectId = null
        },
        /**
         * @description This action is used to get the information from a workflow
         */
        fetchWorkflow (worfkflow_id){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: worfkflow_id })

            this.http.get(url).then(result => {
                this.workflow = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post a workflow
         */
        postWorkflow (){
            let statuses_attributes = this.workflow.statuses
                
            let data = {
                workflow: {
                    name: this.workflow.name,
                    statuses_attributes: statuses_attributes
                }
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}`)

            this.http.post(url, data).then(result => {
                this.workflow = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to update workflow info
         */
        updateWorkflow (){

            let data = {
                workflow: {
                    name: this.workflow.name
                }
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: worfkflow_id })

            this.http.put(url, data).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.submitting = false
            })
        },


        postStatus(){
            this.loading = true 
            let new_status = {
                next_statuses: '',
                status_type: 'normal',
                number: 0,
                name: this.new_status_name
            }
            
            let data = {
                workflow_status: new_status
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/statuses`, { workflowId: this.workflow.id })
            
            this.http.post(url, data).then(result => {
                new_status.id = result.id
                this.new_status_name = ''
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
            
        },

        deleteWorkflowStatus(deleted_status){
            this.loading = true

            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/statuses/:statusId`, { workflowId: this.workflow.id, statusId: deleted_status })

            this.http.delete(url).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },

        updateWorkflowStatus(status_id, actual_status_type){
            this.loading = true

            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/statuses/:statusId`, { workflowId: this.workflow.id, statusId: status_id })

            this.http.put(url, { 
                workflow_status: {   
                    status_type: actual_status_type
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        }


    }
})
