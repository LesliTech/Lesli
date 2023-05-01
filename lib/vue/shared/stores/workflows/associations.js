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

import { useWorkflow } from "Lesli/stores/shared/workflow"

export const useAssociations = defineStore("core.shared.workflow.associations", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            associations: [],
            loading: false,
            options_select: [],
            options: [],
            association_details: {},
            association: {},
            select_details: []
        }
    },
    actions: {
        /**
        * @description This action is used to fetch the list of options for a workflow association
        */
        getAssociationOptions(){
            this.loading = true
            this.options_select = []
            
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/associations/options`)

            this.http.get(url).then(result => {
                this.options = result
                result.forEach((option)=>{
                    this.options_select.push({ 
                        label: option.name, 
                        value: option.workflow_for
                    })

                })

                this.loading = false

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        /**
        * @description This action is used to post a new association for a workflow
        */
        postAssociation(){
            this.loading = true

            let data = {
                workflow_association: this.association
            }

            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/${this.storeWorkflow.workflow.id}/associations`)

            this.http.post(url, data).then(result => {
                this.association = {}
                this.msg.success(I18n.t("core.users.messages_success_operation"))
                this.getAssociations()
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(()=>{
                this.loading = false
            })
        },
        /**
        * @description This action is used to get workflow associations
        */
        getAssociations () {
            this.loading = true
            this.associations = []
            
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/${this.storeWorkflow.workflow.id}/associations`)

            this.http.get(url).then(result => {
                this.associations = result
                this.loading = false
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
        deleteAssociation(association_id){
            const url = this.url[this.storeWorkflow.cloudModule](`${this.storeWorkflow.cloudObject}/${this.storeWorkflow.workflow.id}/associations/:associationId`, {associationId: association_id})

            this.http.delete(url).then(result => {
                this.getAssociations()
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
    }
})
