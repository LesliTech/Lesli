/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/


// · This store is needed to make http requests, manage the reactivity
// · of a workflow.

import { defineStore } from "pinia"
import { toHandlers } from "vue"

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
            new_status_name: '',
            deleted_workflow_statuses: [],
            selected_status: {},
            status_select: [],
            status_transition: null,
            transition_statuses: [],
            list_status: [],

            workflowId: "",
            workflowStatusId: "",
            workflow_statuses: [],
            currentStatus: {}
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
        * @description This action is used to get the statuses from a workflow
        */
        async fetchWorkflowStatuses(){

            this.loading = true


            let cloudObjectScope = null

            if (this.cloudObject.split("/").length >= 2) {
                cloudObjectScope = this.cloudObject.split("/")[0]
            }


            let path = "workflows/:workflow_id/statuses"

            if (cloudObjectScope) {
                path = cloudObjectScope + "/" + path
            }

            let url = this.url[this.cloudModule](path, {
                workflow_id: this.workflowId,
            })

            return this.http.get(url).then(result => {
                this.workflow_statuses = result.sort((a, b) => a.number - b.number)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_transition_options)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
        * @description This action is used to get the current status from workflow statuses
        */
        getCurrentStatus(){
            this.currentStatus = this.workflow_statuses.find((status)=> status.id === this.workflowStatusId)
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
            let cloudObjectSingular = this.utils.singularize(cloudObject)

            let path = "workflows/resources/transition-options/:cloudObject/:cloudObjectId"

            if (cloudObjectScope) {
                path = cloudObjectScope + "/" + path
            }

            if (!url) url = this.url[this.cloudModule](path, {
                cloudObject: cloudObjectSingular,
                cloudObjectId: this.cloudObjectId,
            })

            this.http.get(url).then(result => {
                if (result === "") return this.transitionOptions = []
                this.transitionOptions = result
            }).catch(error => {
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
        async fetchWorkflow (worfkflow_id){
            this.loading = true
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: worfkflow_id })

            return this.http.get(url).then(result => {
                this.workflow = result
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post a workflow
         */
        async postWorkflow (){
            this.loading = true
            let statuses_attributes = this.workflow.statuses
                
            let data = {
                workflow: {
                    name: this.workflow.name,
                    statuses_attributes: statuses_attributes
                }
            }

            const url = this.url[this.cloudModule](`${this.cloudObject}`)

            return this.http.post(url, data).then(result => {
                this.workflow = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to update workflow info
         */
        updateWorkflow(){

            this.loading = true
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: this.workflow.id })

            this.http.put(url, {
                workflow: {
                    name: this.workflow.name
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to post a new status for the actual workflow
         */
        async postStatus(){
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
            
            return this.http.post(url, data).then(result => {
                new_status.id = result.id
                this.new_status_name = ''
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
            
        },
        /**
        * @description This action is used to post delete the actual workflow
        */
        async deleteWorkflow(){
            this.loading = true
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: this.workflow.id })

            return this.http.delete(url).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to update statuses from a workflow
         */
        updateWorkflowStatuses(){

            this.loading = true

            let statuses_attributes = Object.values(this.workflow.statuses).concat(this.deleted_workflow_statuses)

            let data = {
                workflow: {
                    name: this.workflow.name,
                    statuses_attributes: statuses_attributes
                }
            }
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: this.workflow.id })

            this.http.put(url, data).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.deleted_workflow_statuses = []
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })

        },
        /**
         * @description This action is used to post reset workflow values for the workflow form
         */
        resetWorkflow(){
            this.workflow = {}
            this.selected_status = {},
            this.status_select = [],
            this.status_transition = null,
            this.transition_statuses = [],
            this.list_status = []
        }
    }
})
