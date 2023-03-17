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

            tab: 1,
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
                        next_statuses: status?.next_statuses?.split("|") || []
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

            console.log(statuses_attributes)

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
                result.next = []
                this.workflow.statuses.push(result)
                this.status.name = ""
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        }
    }
})
