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
            check: {}
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
        fetchCheck (check_id){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/checks/:checkId`, { workflowId: worfkflow_id, checkId: check_id })

            this.http.get(url).then(result => {
                this.check = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
         * @description This action is used to post a check for a workflow
         */
        postCheck (){
                
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
        }

    }
})
