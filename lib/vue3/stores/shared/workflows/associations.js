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

export const useAssociations = defineStore("core.shared.workflow.associations", {
    state: () => {
        return {
            storeWorkflow: useWorkflow(),
            associations: [],
            loading: false,
            options_select: [],
            options: [],
            association_details: {}
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
    }
})
