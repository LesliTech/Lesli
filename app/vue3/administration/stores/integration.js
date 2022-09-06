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


// · 
import { defineStore } from "pinia"


// · 
export const useIntegration = defineStore("administration.integration", {
    state: () => {
        return {
            token: "",
            records: [],
            pagination: {},
            integration: {
                name: ""
            }
        }
    },
    actions: {

        fetch() {
            this.http.get(this.url.admin("account/integrations")).then(result => {
                this.pagination = result.pagination
                this.records = result.records.map(integrations => {
                    integrations.created_at = this.date.dateTime(integrations.created_at)
                    return integrations
                })
            })
        },

        post() {

            if (this.integration.name == "") {
                return 
            }

            this.http.post(this.url.admin("account/integrations"), {
                account_integration: this.integration
            }).then(result => {
                this.integration.name = ""
                this.token = result
            })
        },

        deleteIntegration(integration_id){
            this.dialog.confirmation({
                title: "Delete integration",
                text: 'Are you sure you want to delete this integration?',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("account/integrations/:id", { id: integration_id})).then(result => {
                        this.msg.success(I18n.t("core.users.messages_success_operation"))
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                    this.fetch()
                }
            })
        }

    }
})
