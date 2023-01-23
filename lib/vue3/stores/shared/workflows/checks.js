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

export const useChecks = defineStore("core.shared.workflow.checks", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            checks: [],
            loading: false,
            check: {},
            showPanel: false,
            options: {
                users: [],
                roles: [],
                statuses: [],
                user_types: []
            }
        }
    },
    actions: {
        /**
        * @description This action is used to fetch the list of checks for a workflow
        */
        fetchChecks() {
            this.loading = true

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.get(url).then(result => {
                this.checks = result
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
            this.check = {}
        },
        /**
         * @description This action is used to get the information from a check
         */
        async fetchCheck (check_id){
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks/:checkId`, { workflowId: this.storeWorkflow.workflow.id, checkId: check_id })
            this.loading = true
            return this.http.get(url).then(result => {
                this.check = result
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post a check for a workflow
         */
        postCheck (){
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks`, { workflowId: this.storeWorkflow.workflow.id })

            this.http.post(url, {
                workflow_check: this.check
            }).then(result => {
                this.check = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
         * @description This action is used to update a check for a workflow
         */
        putCheck(){
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks/:checkId`, { workflowId: this.storeWorkflow.workflow.id, checkId: this.check.id })
            this.loading = true

            this.http.put(url, {
                workflow_check: this.check
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        /**
         * @description This action is used to get options for check form
         */
        getCheckOptions(){
            this.options = {
                users: [],
                roles: [],
                statuses: [],
                user_types: []
            }
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks/options`, { workflowId: this.storeWorkflow.workflow.id })

            this.loading = true

            this.http.get(url).then(result => {

                this.options["users"] = result["users"]

                result["roles"].forEach((role)=>{
                    this.options["roles"].push({
                        label: role.name,
                        value: role.id
                    })
                })

                Object.values(result["statuses"]).forEach((status)=>{
                    this.options["statuses"].push({
                        label: status.name,
                        value: status.id
                    })
                })

                result["user_types"].forEach((type)=>{
                    this.options["user_types"].push({
                        label: type.text,
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
         * @description This action is used to check if the announcement exists to create or update the announcement
         */
        formSubmit() {
            if (this.check.id) {
                this.putCheck()
            } else {
                this.postCheck()
            }
            this.reset()
            this.fetchChecks()
            this.showPanel = false
        },
        /**
         * @description This action is used to delete a check for a workflow
         */
        deleteCheck(check_id){
            this.loading = true
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/checks/:checkId`, { workflowId: this.storeWorkflow.workflow.id, checkId: check_id })

            this.http.delete(url).then(result => {
                this.checks = this.checks.filter(check => check.id != check_id)
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

    }
})
