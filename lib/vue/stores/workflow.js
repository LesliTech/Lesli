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


export const useWorkflow = defineStore("core.shared.workflow", {
    state: () => {
        return {

            tab: 0,
            panelNew: false,
            panelNext: false,
            
            // store the list of available workflows
            workflows: {
                loading: false,
                pagination: {},
                records: []
            },

            // stores the current working workflow
            workflow: { 
                name: ""
            },

            // temporary status selected to work on
            selectedStatus: {},

            // working with statuses, create, update, delete
            status: {
                next_statuses: [],
                status_type: "normal",
                number: 0,
                name: ""
            },

        }
    },
    actions: {

        // get all the available workflows
        fetchWorkflows(url) {
            this.workflows.loading = true

            if (!url) url = this.url[this.cloudModule](this.cloudObject)

            this.http.get(url).then(result => {
                this.workflows.records = result.workflows.map(workflow => {
                    return {
                        id: workflow.id,
                        name: workflow.name,
                        validation: 4, //getValidation(workflow),
                        default: workflow.default,
                        connectedTo: 2 //getConnectedTo(workflow),
                    }
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loading = false
            })
        },


        // Create a workflow with the minimal information
        postWorkflow() {

            let url = this.url[this.cloudModule](`${this.cloudObject}`)

            return this.http.post(url, {
                workflow: {
                    name: this.workflow.name
                }
            }).then(result => {
                this.workflow = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                // TODO: Redirect to show view
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
       },


        // Get specific workflow
        fetchWorkflow (worfkflow_id){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: worfkflow_id })

            this.http.get(url).then(result => {
                this.workflow = result

                this.workflow.statuses = this.workflow.statuses.map(status => {
                    return {
                        id: status.id,
                        name: status.name,
                        number: status.number,
                        status_type: status.status_type,
                        next_statuses: status?.next_statuses || []
                    }
                })

                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },


        // Full workflow update
        putWorkflow() {

            //let statuses_attributes = Object.values(this.workflow.statuses).concat(this.deleted_workflow_statuses)

            let url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId`, { workflowId: this.workflow.id })

            let statuses_attributes = Object.values(this.workflow.statuses)

            this.http.put(url, {
                workflow: {
                    name: this.workflow.name,
                    statuses_attributes: statuses_attributes
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                //this.deleted_workflow_statuses = []
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })

        },


        // Create a new status for the current workflow
        postStatus() {

            let url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/statuses`, { workflowId: this.workflow.id })
            
            return this.http.post(url, {
                workflow_status: this.status
            }).then(result => {
                result.next_statuses = []
                this.workflow.statuses.push(result)
                this.status.name = ""
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        }
    }
})
