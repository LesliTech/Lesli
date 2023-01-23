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

export const useActions = defineStore("core.shared.workflow.actions", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            actions: [],
            loading: false,
            action: {}
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
            this.action = {}
        },
        /**
         * @description This action is used to get the information from a action
         */
        fetchAction (action_id){
            const url = this.url[this.cloudModule](`${this.cloudObject}/:workflowId/actions/:actionId`, { workflowId: worfkflow_id, checkId: action_id })

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

            const url = this.url[this.cloudModule](`${this.cloudObject}/actions`)

            this.http.post(url, data).then(result => {
                this.action = result
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        }

    }
})
