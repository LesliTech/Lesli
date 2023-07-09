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
