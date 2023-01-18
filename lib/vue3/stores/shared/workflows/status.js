/*
Copyright (c) 2022, all rights reserved.

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

import { useWorkflow } from "../workflow"


export const useWorkflowStatus = defineStore("core.shared.workflow.status", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            loading: false,
            status: {
                name: null
            }
        }
    },
    actions: {
        
        /**
        * @param {*}
        * @description 
        */
        postStatus(){
            this.loading = true 
            let new_status = {
                next_statuses: '',
                visited: false,
                status_type: 'normal',
                number: 0,
                new_number: 0,
                name: this.new_status_name
            }
            // if(this.statuses_count == 0){
            //     new_status.status_type = 'initial'
            // }
            // this.statuses_count+=1
            
            let data = {
                workflow_status: new_status
            }

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/:workflowId/statuses`, { workflowId: worfkflow_id })
            
            this.http.post(url, data).then(result => {
                new_status.id = result.id
                this.new_status_name = ''
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
            
        }
        
    }
})
